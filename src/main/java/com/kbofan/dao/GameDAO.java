package com.kbofan.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.kbofan.dto.Game;
import com.kbofan.util.DBUtil;

public class GameDAO {

    // 최근 경기 결과 조회 (완료된 경기만)
    public List<Game> getRecentGames(int limit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT g.*, " +
                "at.name as away_team_name, ht.name as home_team_name, " +
                "at.logo as away_team_logo, ht.logo as home_team_logo " +
                "FROM Game g " +
                "JOIN Team at ON g.away_team = at.team_id " +
                "JOIN Team ht ON g.home_team = ht.team_id " +
                "WHERE g.status = 'COMPLETED' " +
                "ORDER BY g.game_date DESC, g.game_time DESC " +
                "LIMIT ?";
        List<Game> games = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Game game = new Game();
                game.setGameId(rs.getInt("game_id"));
                game.setGameDate(rs.getDate("game_date"));
                game.setGameTime(rs.getString("game_time"));
                game.setStadium(rs.getString("stadium"));
                game.setAwayTeam(rs.getInt("away_team"));
                game.setHomeTeam(rs.getInt("home_team"));

                // NULL 값 처리
                if (rs.getObject("away_score") != null) {
                    game.setAwayScore(rs.getInt("away_score"));
                }
                if (rs.getObject("home_score") != null) {
                    game.setHomeScore(rs.getInt("home_score"));
                }

                game.setAwayPitcher(rs.getString("away_pitcher"));
                game.setAwayPitcherResult(rs.getString("away_pitcher_result"));
                game.setHomePitcher(rs.getString("home_pitcher"));
                game.setHomePitcherResult(rs.getString("home_pitcher_result"));
                game.setAwayTeamName(rs.getString("away_team_name"));
                game.setHomeTeamName(rs.getString("home_team_name"));
                game.setAwayTeamLogo(rs.getString("away_team_logo"));
                game.setHomeTeamLogo(rs.getString("home_team_logo"));
                game.setWinner(rs.getString("winner"));
                game.setStatus(rs.getString("status"));
                game.setEtc(rs.getString("etc"));
                games.add(game);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return games;
    }

    // 예정된 경기 조회 (예정 및 취소된 경기)
    public List<Game> getUpcomingGames(int limit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT g.*, " +
                "at.name as away_team_name, ht.name as home_team_name, " +
                "at.logo as away_team_logo, ht.logo as home_team_logo " +
                "FROM Game g " +
                "JOIN Team at ON g.away_team = at.team_id " +
                "JOIN Team ht ON g.home_team = ht.team_id " +
                "WHERE g.status IN ('SCHEDULED', 'CANCELED') " +
                "AND g.game_date >= CURDATE() " +
                "ORDER BY g.game_date ASC, g.game_time ASC " +
                "LIMIT ?";
        List<Game> games = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Game game = new Game();
                game.setGameId(rs.getInt("game_id"));
                game.setGameDate(rs.getDate("game_date"));
                game.setGameTime(rs.getString("game_time"));
                game.setStadium(rs.getString("stadium"));
                game.setAwayTeam(rs.getInt("away_team"));
                game.setHomeTeam(rs.getInt("home_team"));

                // NULL 값 처리
                if (rs.getObject("away_score") != null) {
                    game.setAwayScore(rs.getInt("away_score"));
                }
                if (rs.getObject("home_score") != null) {
                    game.setHomeScore(rs.getInt("home_score"));
                }

                game.setAwayPitcher(rs.getString("away_pitcher"));
                game.setAwayPitcherResult(rs.getString("away_pitcher_result"));
                game.setHomePitcher(rs.getString("home_pitcher"));
                game.setHomePitcherResult(rs.getString("home_pitcher_result"));
                game.setAwayTeamName(rs.getString("away_team_name"));
                game.setHomeTeamName(rs.getString("home_team_name"));
                game.setAwayTeamLogo(rs.getString("away_team_logo"));
                game.setHomeTeamLogo(rs.getString("home_team_logo"));
                game.setWinner(rs.getString("winner"));
                game.setStatus(rs.getString("status"));
                game.setEtc(rs.getString("etc"));
                games.add(game);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return games;
    }

    // 팀별 경기 결과 조회
    public List<Game> getGamesByTeam(int teamId, int limit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT g.*, " +
                "at.name as away_team_name, ht.name as home_team_name, " +
                "at.logo as away_team_logo, ht.logo as home_team_logo " +
                "FROM Game g " +
                "JOIN Team at ON g.away_team = at.team_id " +
                "JOIN Team ht ON g.home_team = ht.team_id " +
                "WHERE g.away_team = ? OR g.home_team = ? " +
                "ORDER BY g.game_date DESC, g.game_time DESC " +
                "LIMIT ?";
        List<Game> games = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teamId);
            pstmt.setInt(2, teamId);
            pstmt.setInt(3, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Game game = new Game();
                game.setGameId(rs.getInt("game_id"));
                game.setGameDate(rs.getDate("game_date"));
                game.setGameTime(rs.getString("game_time"));
                game.setStadium(rs.getString("stadium"));
                game.setAwayTeam(rs.getInt("away_team"));
                game.setHomeTeam(rs.getInt("home_team"));

                // NULL 값 처리
                if (rs.getObject("away_score") != null) {
                    game.setAwayScore(rs.getInt("away_score"));
                }
                if (rs.getObject("home_score") != null) {
                    game.setHomeScore(rs.getInt("home_score"));
                }

                game.setAwayPitcher(rs.getString("away_pitcher"));
                game.setAwayPitcherResult(rs.getString("away_pitcher_result"));
                game.setHomePitcher(rs.getString("home_pitcher"));
                game.setHomePitcherResult(rs.getString("home_pitcher_result"));
                game.setAwayTeamName(rs.getString("away_team_name"));
                game.setHomeTeamName(rs.getString("home_team_name"));
                game.setAwayTeamLogo(rs.getString("away_team_logo"));
                game.setHomeTeamLogo(rs.getString("home_team_logo"));
                game.setWinner(rs.getString("winner"));
                game.setStatus(rs.getString("status"));
                game.setEtc(rs.getString("etc"));
                games.add(game);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return games;
    }

    // 날짜별 경기 조회
    public List<Game> getGamesByDate(Date date) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String formattedDate = sdf.format(date);

        String sql = "SELECT g.*, " +
                "at.name as away_team_name, ht.name as home_team_name, " +
                "at.logo as away_team_logo, ht.logo as home_team_logo " +
                "FROM Game g " +
                "JOIN Team at ON g.away_team = at.team_id " +
                "JOIN Team ht ON g.home_team = ht.team_id " +
                "WHERE DATE(g.game_date) = ? " +
                "ORDER BY g.game_time ASC";
        List<Game> games = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, formattedDate);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Game game = new Game();
                game.setGameId(rs.getInt("game_id"));
                game.setGameDate(rs.getDate("game_date"));
                game.setGameTime(rs.getString("game_time"));
                game.setStadium(rs.getString("stadium"));
                game.setAwayTeam(rs.getInt("away_team"));
                game.setHomeTeam(rs.getInt("home_team"));

                // NULL 값 처리
                if (rs.getObject("away_score") != null) {
                    game.setAwayScore(rs.getInt("away_score"));
                }
                if (rs.getObject("home_score") != null) {
                    game.setHomeScore(rs.getInt("home_score"));
                }

                game.setAwayPitcher(rs.getString("away_pitcher"));
                game.setAwayPitcherResult(rs.getString("away_pitcher_result"));
                game.setHomePitcher(rs.getString("home_pitcher"));
                game.setHomePitcherResult(rs.getString("home_pitcher_result"));
                game.setAwayTeamName(rs.getString("away_team_name"));
                game.setHomeTeamName(rs.getString("home_team_name"));
                game.setAwayTeamLogo(rs.getString("away_team_logo"));
                game.setHomeTeamLogo(rs.getString("home_team_logo"));
                game.setWinner(rs.getString("winner"));
                game.setStatus(rs.getString("status"));
                game.setEtc(rs.getString("etc"));
                games.add(game);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return games;
    }

    // 날짜 범위로 경기 조회
    public List<Game> getGamesByDateRange(Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String formattedStartDate = sdf.format(startDate);
        String formattedEndDate = sdf.format(endDate);

        String sql = "SELECT g.*, " +
                "at.name as away_team_name, ht.name as home_team_name, " +
                "at.logo as away_team_logo, ht.logo as home_team_logo " +
                "FROM Game g " +
                "JOIN Team at ON g.away_team = at.team_id " +
                "JOIN Team ht ON g.home_team = ht.team_id " +
                "WHERE g.game_date BETWEEN ? AND ? " +
                "ORDER BY g.game_date ASC, g.game_time ASC";
        List<Game> games = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, formattedStartDate);
            pstmt.setString(2, formattedEndDate);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Game game = new Game();
                game.setGameId(rs.getInt("game_id"));
                game.setGameDate(rs.getDate("game_date"));
                game.setGameTime(rs.getString("game_time"));
                game.setStadium(rs.getString("stadium"));
                game.setAwayTeam(rs.getInt("away_team"));
                game.setHomeTeam(rs.getInt("home_team"));

                // NULL 값 처리
                if (rs.getObject("away_score") != null) {
                    game.setAwayScore(rs.getInt("away_score"));
                }
                if (rs.getObject("home_score") != null) {
                    game.setHomeScore(rs.getInt("home_score"));
                }

                game.setAwayPitcher(rs.getString("away_pitcher"));
                game.setAwayPitcherResult(rs.getString("away_pitcher_result"));
                game.setHomePitcher(rs.getString("home_pitcher"));
                game.setHomePitcherResult(rs.getString("home_pitcher_result"));
                game.setAwayTeamName(rs.getString("away_team_name"));
                game.setHomeTeamName(rs.getString("home_team_name"));
                game.setAwayTeamLogo(rs.getString("away_team_logo"));
                game.setHomeTeamLogo(rs.getString("home_team_logo"));
                game.setWinner(rs.getString("winner"));
                game.setStatus(rs.getString("status"));
                game.setEtc(rs.getString("etc"));
                games.add(game);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return games;
    }

    // 경기 정보 업데이트
    public boolean updateGame(Game game) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE Game SET game_date = ?, game_time = ?, stadium = ?, " +
                "away_team = ?, home_team = ?, away_score = ?, home_score = ?, " +
                "away_pitcher = ?, away_pitcher_result = ?, home_pitcher = ?, " +
                "home_pitcher_result = ?, winner = ?, etc = ?, status = ? " +
                "WHERE game_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 날짜 형식 변환
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String formattedDate = sdf.format(game.getGameDate());

            pstmt.setString(1, formattedDate);
            pstmt.setString(2, game.getGameTime());
            pstmt.setString(3, game.getStadium());
            pstmt.setInt(4, game.getAwayTeam());
            pstmt.setInt(5, game.getHomeTeam());

            if (game.getAwayScore() != null) {
                pstmt.setInt(6, game.getAwayScore());
            } else {
                pstmt.setNull(6, java.sql.Types.INTEGER);
            }

            if (game.getHomeScore() != null) {
                pstmt.setInt(7, game.getHomeScore());
            } else {
                pstmt.setNull(7, java.sql.Types.INTEGER);
            }

            pstmt.setString(8, game.getAwayPitcher());
            pstmt.setString(9, game.getAwayPitcherResult());
            pstmt.setString(10, game.getHomePitcher());
            pstmt.setString(11, game.getHomePitcherResult());
            pstmt.setString(12, game.getWinner());
            pstmt.setString(13, game.getEtc());
            pstmt.setString(14, game.getStatus());
            pstmt.setInt(15, game.getGameId());

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // 경기 ID로 조회
    public Game getGameById(int gameId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT g.*, " +
                "at.name as away_team_name, ht.name as home_team_name, " +
                "at.logo as away_team_logo, ht.logo as home_team_logo " +
                "FROM Game g " +
                "JOIN Team at ON g.away_team = at.team_id " +
                "JOIN Team ht ON g.home_team = ht.team_id " +
                "WHERE g.game_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, gameId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Game game = new Game();
                game.setGameId(rs.getInt("game_id"));
                game.setGameDate(rs.getDate("game_date"));
                game.setGameTime(rs.getString("game_time"));
                game.setStadium(rs.getString("stadium"));
                game.setAwayTeam(rs.getInt("away_team"));
                game.setHomeTeam(rs.getInt("home_team"));

                // NULL 값 처리
                if (rs.getObject("away_score") != null) {
                    game.setAwayScore(rs.getInt("away_score"));
                }
                if (rs.getObject("home_score") != null) {
                    game.setHomeScore(rs.getInt("home_score"));
                }

                game.setAwayPitcher(rs.getString("away_pitcher"));
                game.setAwayPitcherResult(rs.getString("away_pitcher_result"));
                game.setHomePitcher(rs.getString("home_pitcher"));
                game.setHomePitcherResult(rs.getString("home_pitcher_result"));
                game.setAwayTeamName(rs.getString("away_team_name"));
                game.setHomeTeamName(rs.getString("home_team_name"));
                game.setAwayTeamLogo(rs.getString("away_team_logo"));
                game.setHomeTeamLogo(rs.getString("home_team_logo"));
                game.setWinner(rs.getString("winner"));
                game.setStatus(rs.getString("status"));
                game.setEtc(rs.getString("etc"));
                return game;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return null;
    }

    // 관리자 계정 추가
    public boolean addAdminAccount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO User (username, password, role) VALUES ('admin', 'password', 'ADMIN')";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            // 관리자 계정이 이미 존재하는 경우 예외 처리
            if (e.getErrorCode() == 1062) { // MySQL의 Duplicate entry 에러 코드
                System.out.println("Admin account already exists.");
                return false;
            }
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // 경기 추가
    public boolean addGame(Game game) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO Game (game_date, game_time, stadium, away_team, home_team, " +
                "away_score, home_score, away_pitcher, away_pitcher_result, home_pitcher, " +
                "home_pitcher_result, winner, etc, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 날짜 형식 변환
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String formattedDate = sdf.format(game.getGameDate());

            pstmt.setString(1, formattedDate);
            pstmt.setString(2, game.getGameTime());
            pstmt.setString(3, game.getStadium());
            pstmt.setInt(4, game.getAwayTeam());
            pstmt.setInt(5, game.getHomeTeam());

            if (game.getAwayScore() != null) {
                pstmt.setInt(6, game.getAwayScore());
            } else {
                pstmt.setNull(6, java.sql.Types.INTEGER);
            }

            if (game.getHomeScore() != null) {
                pstmt.setInt(7, game.getHomeScore());
            } else {
                pstmt.setNull(7, java.sql.Types.INTEGER);
            }

            pstmt.setString(8, game.getAwayPitcher());
            pstmt.setString(9, game.getAwayPitcherResult());
            pstmt.setString(10, game.getHomePitcher());
            pstmt.setString(11, game.getHomePitcherResult());
            pstmt.setString(12, game.getWinner());
            pstmt.setString(13, game.getEtc());
            pstmt.setString(14, game.getStatus());

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // 경기 삭제
    public boolean deleteGame(int gameId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "DELETE FROM Game WHERE game_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, gameId);

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    public int getTotalGameCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM Game";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return 0;
    }

    public int getTodayGameCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM Game WHERE game_date = CURDATE()";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return 0;
    }
}
