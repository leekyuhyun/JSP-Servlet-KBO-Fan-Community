package com.kbofan.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.kbofan.dto.User;
import com.kbofan.util.DBUtil;
import com.kbofan.util.HashUtil;

public class UserDAO {

    // 사용자 등록
    public boolean registerUser(User user) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        // is_admin 컬럼 제거
        String sql = "INSERT INTO User (username, login_id, nickname, password, email, team_id) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getLoginId());
            pstmt.setString(3, user.getNickname());
            pstmt.setString(4, HashUtil.hashPassword(user.getPassword()));
            pstmt.setString(5, user.getEmail());
            pstmt.setInt(6, user.getTeamId());
            // is_admin 파라미터 제거

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // 로그인 ID로 사용자 조회
    public User getUserByLoginId(String loginId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT u.user_id, u.username, u.login_id, u.nickname, u.password, u.email, u.team_id, u.created_at, " +
                "t.name as team_name, t.logo as team_logo, " +
                "t.primary_color as team_primary_color, t.secondary_color as team_secondary_color " +
                "FROM User u " +
                "LEFT JOIN Team t ON u.team_id = t.team_id " +
                "WHERE u.login_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loginId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setLoginId(rs.getString("login_id"));
                user.setNickname(rs.getString("nickname"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setTeamId(rs.getInt("team_id"));

                // 팀 정보 설정
                user.setTeamName(rs.getString("team_name"));
                user.setTeamLogo(rs.getString("team_logo"));
                user.setTeamPrimaryColor(rs.getString("team_primary_color"));
                user.setTeamSecondaryColor(rs.getString("team_secondary_color"));

                // 관리자 권한 설정
                if ("admin".equals(loginId)) {
                    user.setAdmin(true);
                } else {
                    user.setAdmin(false);
                }

                System.out.println("User loaded from DB: " + user.getUsername() + " (ID: " + user.getUserId() + ")");
                return user;
            } else {
                System.out.println("No user found with login_id: " + loginId);
            }
        } catch (SQLException e) {
            System.out.println("Error in getUserByLoginId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return null;
    }

    // 로그인 검증
    public User validateLogin(String loginId, String password) {
        User user = getUserByLoginId(loginId);

        if (user != null) {
            boolean passwordMatch = HashUtil.verifyPassword(password, user.getPassword());
            if (passwordMatch) {
                return user;
            }
        }

        return null;
    }

    // 로그인 ID 중복 확인
    public boolean isLoginIdAvailable(String loginId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM User WHERE login_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loginId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return false;
    }
    // 이름과 이메일로 아이디 찾기
    public String findLoginIdByNameAndEmail(String username, String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT login_id FROM User WHERE username = ? AND email = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getString("login_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return null;
    }

    // 아이디와 이메일로 사용자 찾기
    public User findUserByLoginIdAndEmail(String loginId, String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM User WHERE login_id = ? AND email = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loginId);
            pstmt.setString(2, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setLoginId(rs.getString("login_id"));
                user.setNickname(rs.getString("nickname"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setTeamId(rs.getInt("team_id"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return null;
    }

    // 비밀번호 업데이트
    public boolean updatePassword(int userId, String newPassword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE User SET password = ? WHERE user_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, HashUtil.hashPassword(newPassword));
            pstmt.setInt(2, userId);

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // 사용자 정보 업데이트
    public boolean updateUser(User user, boolean updatePassword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql;

        if (updatePassword) {
            sql = "UPDATE User SET username = ?, nickname = ?, email = ?, team_id = ?, password = ? WHERE user_id = ?";
        } else {
            sql = "UPDATE User SET username = ?, nickname = ?, email = ?, team_id = ? WHERE user_id = ?";
        }

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getNickname());
            pstmt.setString(3, user.getEmail());
            pstmt.setInt(4, user.getTeamId());

            if (updatePassword) {
                pstmt.setString(5, HashUtil.hashPassword(user.getPassword()));
                pstmt.setInt(6, user.getUserId());
            } else {
                pstmt.setInt(5, user.getUserId());
            }

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // 사용자 목록 조회 (페이징, 검색 지원)
    public List<User> getUserList(String searchType, String searchKeyword, int page, int pageSize) {
        List<User> users = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.user_id, u.username, u.login_id, u.nickname, u.email, u.team_id, u.created_at, ")
                .append("t.name as team_name, t.logo as team_logo ")
                .append("FROM User u ")
                .append("LEFT JOIN Team t ON u.team_id = t.team_id ")
                .append("WHERE 1=1 ");

        // 검색 조건
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            switch (searchType) {
                case "username":
                    sql.append("AND u.username LIKE ? ");
                    break;
                case "nickname":
                    sql.append("AND u.nickname LIKE ? ");
                    break;
                case "loginId":
                    sql.append("AND u.login_id LIKE ? ");
                    break;
                case "email":
                    sql.append("AND u.email LIKE ? ");
                    break;
                case "all":
                    sql.append("AND (u.username LIKE ? OR u.nickname LIKE ? OR u.login_id LIKE ? OR u.email LIKE ?) ");
                    break;
            }
        }

        sql.append("ORDER BY u.created_at DESC ")
                .append("LIMIT ? OFFSET ?");

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());

            int paramIndex = 1;

            // 검색 파라미터
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = "%" + searchKeyword.trim() + "%";
                switch (searchType) {
                    case "username":
                    case "nickname":
                    case "loginId":
                    case "email":
                        pstmt.setString(paramIndex++, keyword);
                        break;
                    case "all":
                        pstmt.setString(paramIndex++, keyword);
                        pstmt.setString(paramIndex++, keyword);
                        pstmt.setString(paramIndex++, keyword);
                        pstmt.setString(paramIndex++, keyword);
                        break;
                }
            }

            // 페이징 파라미터
            pstmt.setInt(paramIndex++, pageSize);
            pstmt.setInt(paramIndex, (page - 1) * pageSize);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setLoginId(rs.getString("login_id"));
                user.setNickname(rs.getString("nickname"));
                user.setEmail(rs.getString("email"));
                user.setTeamId(rs.getInt("team_id"));
                user.setTeamName(rs.getString("team_name"));
                user.setTeamLogo(rs.getString("team_logo"));

                users.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error in getUserList: " + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return users;
    }

    // 전체 사용자 수 조회
    public int getTotalUserCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM User";

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

    // 검색 조건에 따른 사용자 수 조회
    public int getTotalUserCount(String searchType, String searchKeyword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM User u WHERE 1=1 ");

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            switch (searchType) {
                case "username":
                    sql.append("AND u.username LIKE ? ");
                    break;
                case "nickname":
                    sql.append("AND u.nickname LIKE ? ");
                    break;
                case "loginId":
                    sql.append("AND u.login_id LIKE ? ");
                    break;
                case "email":
                    sql.append("AND u.email LIKE ? ");
                    break;
                case "all":
                    sql.append("AND (u.username LIKE ? OR u.nickname LIKE ? OR u.login_id LIKE ? OR u.email LIKE ?) ");
                    break;
            }
        }

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());

            int paramIndex = 1;

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = "%" + searchKeyword.trim() + "%";
                switch (searchType) {
                    case "username":
                    case "nickname":
                    case "loginId":
                    case "email":
                        pstmt.setString(paramIndex++, keyword);
                        break;
                    case "all":
                        pstmt.setString(paramIndex++, keyword);
                        pstmt.setString(paramIndex++, keyword);
                        pstmt.setString(paramIndex++, keyword);
                        pstmt.setString(paramIndex++, keyword);
                        break;
                }
            }

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error in getTotalUserCount: " + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return 0;
    }

    // 특정 기간 내 신규 가입자 수 조회
    public int getNewUserCount(int days) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM User WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, days);
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

    // 사용자 삭제 (관리자용)
    public boolean deleteUser(int userId) {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. 댓글 좋아요 삭제
            String deleteCommentLikes = "DELETE FROM comment_likes WHERE user_id = ?";
            pstmt1 = conn.prepareStatement(deleteCommentLikes);
            pstmt1.setInt(1, userId);
            pstmt1.executeUpdate();

            // 2. 게시글 좋아요 삭제
            String deleteCommunityLikes = "DELETE FROM community_likes WHERE user_id = ?";
            pstmt2 = conn.prepareStatement(deleteCommunityLikes);
            pstmt2.setInt(1, userId);
            pstmt2.executeUpdate();

            // 3. 댓글 삭제 (소프트 삭제)
            String deleteComments = "UPDATE comments SET is_deleted = TRUE WHERE author_id = ?";
            pstmt3 = conn.prepareStatement(deleteComments);
            pstmt3.setInt(1, userId);
            pstmt3.executeUpdate();

            // 4. 게시글 삭제 (소프트 삭제)
            String deleteCommunity = "UPDATE community SET is_deleted = TRUE WHERE author_id = ?";
            pstmt4 = conn.prepareStatement(deleteCommunity);
            pstmt4.setInt(1, userId);
            pstmt4.executeUpdate();

            // 5. 사용자 삭제
            String deleteUser = "DELETE FROM User WHERE user_id = ?";
            pstmt5 = conn.prepareStatement(deleteUser);
            pstmt5.setInt(1, userId);
            int result = pstmt5.executeUpdate();

            conn.commit();
            return result > 0;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (pstmt1 != null) try { pstmt1.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt2 != null) try { pstmt2.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt3 != null) try { pstmt3.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt4 != null) try { pstmt4.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt5 != null) try { pstmt5.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
