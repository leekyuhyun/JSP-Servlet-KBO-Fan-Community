package com.kbofan.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kbofan.dto.Team;
import com.kbofan.util.DBUtil;

public class TeamDAO {

    // 모든 팀 조회
    public List<Team> getAllTeams() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM Team ORDER BY name";
        List<Team> teams = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Team team = new Team();
                team.setTeamId(rs.getInt("team_id"));
                team.setName(rs.getString("name"));
                team.setLogo(rs.getString("logo"));
                team.setOfficialSite(rs.getString("official_site"));
                team.setPrimaryColor(rs.getString("primary_color"));
                team.setSecondaryColor(rs.getString("secondary_color"));
                team.setFoundedYear(rs.getInt("founded_year"));
                team.setDescription(rs.getString("description"));
                team.setLong_description(rs.getString("long_description"));
                team.setStadium_name(rs.getString("stadium_name"));
                team.setStadium_lat(rs.getDouble("stadium_lat"));
                team.setStadium_lng(rs.getDouble("stadium_lng"));
                team.setChampionships(rs.getInt("championships"));
                team.setChampionshipYears(rs.getString("championship_years"));

                // 승, 패, 무는 Game 테이블에서 계산하므로 초기값 0으로 설정
                team.setWins(0);
                team.setLosses(0);
                team.setDraws(0);

                teams.add(team);
            }

            System.out.println("팀 데이터 로드 완료: " + teams.size() + "개 팀");

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("팀 데이터 로드 중 오류 발생: " + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return teams;
    }

    // ID로 팀 조회
    public Team getTeamById(int teamId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM Team WHERE team_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teamId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Team team = new Team();
                team.setTeamId(rs.getInt("team_id"));
                team.setName(rs.getString("name"));
                team.setLogo(rs.getString("logo"));
                team.setOfficialSite(rs.getString("official_site"));
                team.setPrimaryColor(rs.getString("primary_color"));
                team.setSecondaryColor(rs.getString("secondary_color"));
                team.setFoundedYear(rs.getInt("founded_year"));
                team.setDescription(rs.getString("description"));
                team.setLong_description(rs.getString("long_description"));
                team.setStadium_name(rs.getString("stadium_name"));
                team.setStadium_lat(rs.getDouble("stadium_lat"));
                team.setStadium_lng(rs.getDouble("stadium_lng"));
                team.setChampionships(rs.getInt("championships"));
                team.setChampionshipYears(rs.getString("championship_years"));
                return team;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return null;
    }

    // 팀 순위 계산 - 공동 순위 처리 추가
    private void calculateRankings(List<Team> teams) {
        if (teams == null || teams.isEmpty()) {
            return;
        }

        // 승률에 따라 정렬
        Collections.sort(teams, new Comparator<Team>() {
            @Override
            public int compare(Team t1, Team t2) {
                return Double.compare(t2.getWinningPercentage(), t1.getWinningPercentage());
            }
        });

        // 공동 순위 처리
        int currentRank = 1;
        int teamsWithSameRank = 0;
        double previousWinningPercentage = -1;

        for (int i = 0; i < teams.size(); i++) {
            Team team = teams.get(i);
            double currentWinningPercentage = team.getWinningPercentage();

            // 첫 번째 팀이거나 이전 팀과 승률이 다른 경우
            if (i == 0 || currentWinningPercentage != previousWinningPercentage) {
                // 이전에 공동 순위가 있었다면 건너뛰기
                if (i > 0) {
                    currentRank += teamsWithSameRank;
                }
                team.setRank(currentRank);
                teamsWithSameRank = 1;
            } else {
                // 이전 팀과 승률이 같은 경우 (공동 순위)
                team.setRank(currentRank);
                teamsWithSameRank++;
            }

            previousWinningPercentage = currentWinningPercentage;
        }

        // 게임차 계산
        Team topTeam = teams.get(0);
        for (Team team : teams) {
            if (team.getRank() == 1) {
                team.setGamesBehind(0.0);
            } else {
                double gamesBehind = ((topTeam.getWins() - team.getWins()) + (team.getLosses() - topTeam.getLosses())) / 2.0;
                team.setGamesBehind(gamesBehind);
            }
        }

        // 디버깅용 로그
        System.out.println("팀 순위 계산 완료 (공동 순위 처리)");
        for (Team team : teams) {
            System.out.println(team.getRank() + ". " + team.getName() + ": 승=" + team.getWins() + ", 패=" + team.getLosses() + ", 무=" + team.getDraws() + ", 승률=" + team.getWinningPercentage() + ", 게임차=" + team.getGamesBehind());
        }
    }

    // 팀 순위 조회 - Game 테이블 데이터 기반으로 계산
    public List<Team> getTeamRankings() {
        System.out.println("팀 순위 계산 시작");
        List<Team> teams = getAllTeams();
        Map<Integer, Team> teamIdMap = new HashMap<>();

        // 팀 ID로 빠르게 접근하기 위한 맵 생성
        for (Team team : teams) {
            teamIdMap.put(team.getTeamId(), team);
            System.out.println("팀 맵에 추가: ID=" + team.getTeamId() + ", 이름=" + team.getName());
        }

        // Game 테이블 구조 확인
        printGameTableStructure();

        // Game 테이블 샘플 데이터 출력
        printGameTableSampleData();

        // Game 테이블에서 경기 결과 가져와서 승, 패, 무 계산
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM Game";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            System.out.println("Game 테이블 조회 시작");
            int gameCount = 0;
            int completedCount = 0;
            int drawCount = 0;

            while (rs.next()) {
                gameCount++;
                int gameId = rs.getInt("game_id");
                int homeTeamId = rs.getInt("home_team");
                int awayTeamId = rs.getInt("away_team");
                int homeScore = rs.getInt("home_score");
                int awayScore = rs.getInt("away_score");
                String winnerName = rs.getString("winner");
                String status = rs.getString("status");

                System.out.println("경기 ID: " + gameId +
                        ", 홈팀 ID: " + homeTeamId +
                        ", 원정팀 ID: " + awayTeamId +
                        ", 홈팀 점수: " + homeScore +
                        ", 원정팀 점수: " + awayScore +
                        ", 승자: " + (winnerName == null ? "null" : winnerName) +
                        ", 상태: " + status);

                // 경기 상태가 COMPLETED인 경우만 처리
                if ("COMPLETED".equals(status)) {
                    completedCount++;

                    // 홈팀과 원정팀 객체 가져오기
                    Team homeTeam = teamIdMap.get(homeTeamId);
                    Team awayTeam = teamIdMap.get(awayTeamId);

                    if (homeTeam == null || awayTeam == null) {
                        System.out.println("경기 ID " + gameId + "에 대한 팀 정보를 찾을 수 없습니다. 홈팀 ID: " + homeTeamId + ", 원정팀 ID: " + awayTeamId);
                        continue;
                    }

                    System.out.println("홈팀: " + homeTeam.getName() + ", 원정팀: " + awayTeam.getName());

                    // 점수가 같으면 무승부
                    if (homeScore == awayScore) {
                        homeTeam.setDraws(homeTeam.getDraws() + 1);
                        awayTeam.setDraws(awayTeam.getDraws() + 1);
                        drawCount++;
                        System.out.println("무승부 처리: " + homeTeam.getName() + " vs " + awayTeam.getName() +
                                ", 홈팀 무: " + homeTeam.getDraws() + ", 원정팀 무: " + awayTeam.getDraws());
                    } else if (homeScore > awayScore) {
                        // 홈팀 승리
                        homeTeam.setWins(homeTeam.getWins() + 1);
                        awayTeam.setLosses(awayTeam.getLosses() + 1);
                        System.out.println("승패 처리: 승자=" + homeTeam.getName() + ", 패자=" + awayTeam.getName());
                    } else {
                        // 원정팀 승리
                        awayTeam.setWins(awayTeam.getWins() + 1);
                        homeTeam.setLosses(homeTeam.getLosses() + 1);
                        System.out.println("승패 처리: 승자=" + awayTeam.getName() + ", 패자=" + homeTeam.getName());
                    }
                }
            }

            System.out.println("총 " + gameCount + "개의 경기 중 " + completedCount + "개 완료, 무승부 경기: " + drawCount + "개");

            // 승률 계산
            for (Team team : teams) {
                team.calculateWinningPercentage();
                System.out.println(team.getName() + ": 승=" + team.getWins() + ", 패=" + team.getLosses() + ", 무=" + team.getDraws() + ", 승률=" + team.getWinningPercentage());
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("경기 결과 처리 중 오류 발생: " + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        calculateRankings(teams);
        return teams;
    }

    // Game 테이블 구조 확인
    private void printGameTableStructure() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("DESCRIBE Game");
            rs = pstmt.executeQuery();

            System.out.println("Game 테이블 구조:");
            while (rs.next()) {
                System.out.println(rs.getString(1) + " - " + rs.getString(2) + " - " + rs.getString(3));
            }
        } catch (SQLException e) {
            System.out.println("Game 테이블 구조 확인 중 오류: " + e.getMessage());
            try {
                // MySQL이 아닌 경우 다른 방법으로 시도
                pstmt = conn.prepareStatement("SELECT * FROM Game LIMIT 0");
                rs = pstmt.executeQuery();
                java.sql.ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();

                System.out.println("Game 테이블 구조 (메타데이터):");
                for (int i = 1; i <= columnCount; i++) {
                    System.out.println(metaData.getColumnName(i) + " - " + metaData.getColumnTypeName(i));
                }
            } catch (SQLException e2) {
                System.out.println("Game 테이블 메타데이터 확인 중 오류: " + e2.getMessage());
            }
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
    }

    // Game 테이블 샘플 데이터 출력
    private void printGameTableSampleData() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("SELECT * FROM Game LIMIT 5");
            rs = pstmt.executeQuery();

            System.out.println("Game 테이블 샘플 데이터:");
            java.sql.ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            // 컬럼 이름 출력
            for (int i = 1; i <= columnCount; i++) {
                System.out.print(metaData.getColumnName(i) + "\t");
            }
            System.out.println();

            // 데이터 출력
            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    System.out.print(rs.getString(i) + "\t");
                }
                System.out.println();
            }
        } catch (SQLException e) {
            System.out.println("Game 테이블 샘플 데이터 확인 중 오류: " + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
    }
}
