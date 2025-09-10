package com.kbofan.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import com.kbofan.util.DBUtil;

@WebServlet("/upload-game-data")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10,  // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class GameDataUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("upload_game_data.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("csvFile");

        if (filePart == null) {
            request.setAttribute("errorMessage", "파일을 선택해주세요.");
            request.getRequestDispatcher("upload_game_data.jsp").forward(request, response);
            return;
        }

        // 팀 이름과 ID 매핑 가져오기
        Map<String, Integer> teamMap = getTeamMap();

        // CSV 파일 처리
        List<String> errorMessages = new ArrayList<>();
        int successCount = 0;

        try (InputStream inputStream = filePart.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"))) {

            String line;
            boolean isFirstLine = true;

            while ((line = reader.readLine()) != null) {
                // 첫 번째 줄(헤더)은 건너뛰기
                if (isFirstLine) {
                    isFirstLine = false;
                    continue;
                }

                try {
                    // CSV 라인 파싱 및 데이터베이스에 삽입
                    if (processGameData(line, teamMap)) {
                        successCount++;
                    } else {
                        errorMessages.add("데이터 처리 중 오류 발생: " + line);
                    }
                } catch (Exception e) {
                    errorMessages.add("라인 처리 중 오류 발생: " + line + " - " + e.getMessage());
                }
            }

            // 결과 메시지 설정
            if (errorMessages.isEmpty()) {
                request.setAttribute("successMessage", successCount + "개의 경기 데이터가 성공적으로 업로드되었습니다.");
            } else {
                request.setAttribute("successMessage", successCount + "개의 경기 데이터가 업로드되었으나, " + errorMessages.size() + "개의 오류가 발생했습니다.");
                request.setAttribute("errorMessages", errorMessages);
            }

            request.getRequestDispatcher("upload_game_data.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "파일 처리 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("upload_game_data.jsp").forward(request, response);
        }
    }

    private Map<String, Integer> getTeamMap() {
        Map<String, Integer> teamMap = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("SELECT team_id, name FROM Team");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                teamMap.put(rs.getString("name"), rs.getInt("team_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return teamMap;
    }

    private boolean processGameData(String line, Map<String, Integer> teamMap) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // CSV 라인 파싱
            String[] data = line.split(",");
            if (data.length < 13) {
                return false;
            }

            // 날짜 형식 변환
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy.MM.dd");
            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date gameDate = inputFormat.parse(data[0]);
            String formattedDate = outputFormat.format(gameDate);

            // 팀 ID 가져오기
            Integer awayTeamId = teamMap.get(data[3]);
            Integer homeTeamId = teamMap.get(data[4]);

            if (awayTeamId == null || homeTeamId == null) {
                return false;
            }

            // 경기 상태 결정
            String status = "SCHEDULED";
            String etc = data.length > 12 ? data[12] : null;

            if (etc != null) {
                if (etc.contains("취소")) {
                    status = "CANCELED";
                } else if (etc.contains("종료")) {
                    status = "COMPLETED";
                }
            }

            // 점수 및 투수 정보 처리
            Integer awayScore = null;
            Integer homeScore = null;
            String awayPitcher = null;
            String awayPitcherResult = null;
            String homePitcher = null;
            String homePitcherResult = null;
            String winner = null;

            // 취소된 경기는 투수 정보가 있더라도 점수와 승리팀 정보는 NULL로 처리
            if ("COMPLETED".equals(status)) {
                // 완료된 경기만 점수와 승리팀 정보 설정
                if (!data[5].trim().isEmpty()) {
                    awayScore = Integer.parseInt(data[5]);
                }
                if (!data[6].trim().isEmpty()) {
                    homeScore = Integer.parseInt(data[6]);
                }
                winner = data[11];
            }

            // 투수 정보는 있는 그대로 저장 (취소된 경기도 투수 정보가 있을 수 있음)
            awayPitcher = data[7].trim().isEmpty() ? null : data[7];
            awayPitcherResult = data[8].trim().isEmpty() ? null : data[8];
            homePitcher = data[9].trim().isEmpty() ? null : data[9];
            homePitcherResult = data[10].trim().isEmpty() ? null : data[10];

            // 데이터베이스에 삽입
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(
                    "INSERT INTO Game (game_date, game_time, stadium, away_team, home_team, away_score, home_score, " +
                            "away_pitcher, away_pitcher_result, home_pitcher, home_pitcher_result, winner, etc, status) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );

            pstmt.setString(1, formattedDate);
            pstmt.setString(2, data[1]);
            pstmt.setString(3, data[2]);
            pstmt.setInt(4, awayTeamId);
            pstmt.setInt(5, homeTeamId);

            if (awayScore != null) {
                pstmt.setInt(6, awayScore);
            } else {
                pstmt.setNull(6, java.sql.Types.INTEGER);
            }

            if (homeScore != null) {
                pstmt.setInt(7, homeScore);
            } else {
                pstmt.setNull(7, java.sql.Types.INTEGER);
            }

            pstmt.setString(8, awayPitcher);
            pstmt.setString(9, awayPitcherResult);
            pstmt.setString(10, homePitcher);
            pstmt.setString(11, homePitcherResult);
            pstmt.setString(12, winner);
            pstmt.setString(13, etc);
            pstmt.setString(14, status);

            int result = pstmt.executeUpdate();
            return result > 0;

        } catch (SQLException | ParseException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }
}
