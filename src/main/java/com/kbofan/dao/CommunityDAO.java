package com.kbofan.dao;

import com.kbofan.dto.Community;
import com.kbofan.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommunityDAO {

    // 게시글 목록 조회 (페이징, 카테고리, 검색 지원)
    public List<Community> getCommunityList(String category, String searchType, String searchKeyword, int page, int pageSize) {
        List<Community> communities = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        // User와 Team 테이블 조인하여 팀 정보 가져오기, 이미지 경로 추가
        sql.append("SELECT c.community_id, c.title, c.content, c.author_id, c.category, ")
                .append("c.created_at, c.updated_at, c.view_count, c.like_count, c.comment_count, ")
                .append("c.image_path, c.original_filename, ")
                .append("u.nickname as author_nickname, t.name as author_team_name ")
                .append("FROM community c ")
                .append("JOIN User u ON c.author_id = u.user_id ")
                .append("LEFT JOIN Team t ON u.team_id = t.team_id ")
                .append("WHERE c.is_deleted = FALSE ");

        // 카테고리 필터
        if (category != null && !category.equals("all")) {
            sql.append("AND c.category = ? ");
        }

        // 검색 조건
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            switch (searchType) {
                case "title":
                    sql.append("AND c.title LIKE ? ");
                    break;
                case "content":
                    sql.append("AND c.content LIKE ? ");
                    break;
                case "author":
                    sql.append("AND u.nickname LIKE ? ");
                    break;
                case "all":
                    sql.append("AND (c.title LIKE ? OR c.content LIKE ? OR u.nickname LIKE ?) ");
                    break;
            }
        }

        sql.append("ORDER BY c.created_at DESC ")
                .append("LIMIT ? OFFSET ?");

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());

            int paramIndex = 1;

            // 카테고리 파라미터
            if (category != null && !category.equals("all")) {
                pstmt.setString(paramIndex++, category);
            }

            // 검색 파라미터
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = "%" + searchKeyword.trim() + "%";
                switch (searchType) {
                    case "title":
                    case "content":
                    case "author":
                        pstmt.setString(paramIndex++, keyword);
                        break;
                    case "all":
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
                Community community = new Community();
                community.setCommunityId(rs.getInt("community_id"));
                community.setTitle(rs.getString("title"));
                community.setContent(rs.getString("content"));
                community.setAuthorId(rs.getInt("author_id"));
                community.setAuthorNickname(rs.getString("author_nickname"));
                community.setAuthorTeamName(rs.getString("author_team_name"));
                community.setCategory(rs.getString("category"));
                community.setCreatedAt(rs.getTimestamp("created_at"));
                community.setUpdatedAt(rs.getTimestamp("updated_at"));
                community.setViewCount(rs.getInt("view_count"));
                community.setLikeCount(rs.getInt("like_count"));
                community.setCommentCount(rs.getInt("comment_count"));
                community.setImagePath(rs.getString("image_path"));
                community.setOriginalFileName(rs.getString("original_filename"));

                communities.add(community);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error in getCommunityList: " + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return communities;
    }

    // 전체 게시글 수 조회
    public int getTotalCount(String category, String searchType, String searchKeyword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM community c ")
                .append("JOIN User u ON c.author_id = u.user_id ")
                .append("LEFT JOIN Team t ON u.team_id = t.team_id ")
                .append("WHERE c.is_deleted = FALSE ");

        if (category != null && !category.equals("all")) {
            sql.append("AND c.category = ? ");
        }

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            switch (searchType) {
                case "title":
                    sql.append("AND c.title LIKE ? ");
                    break;
                case "content":
                    sql.append("AND c.content LIKE ? ");
                    break;
                case "author":
                    sql.append("AND u.nickname LIKE ? ");
                    break;
                case "all":
                    sql.append("AND (c.title LIKE ? OR c.content LIKE ? OR u.nickname LIKE ?) ");
                    break;
            }
        }

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());

            int paramIndex = 1;

            if (category != null && !category.equals("all")) {
                pstmt.setString(paramIndex++, category);
            }

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = "%" + searchKeyword.trim() + "%";
                switch (searchType) {
                    case "title":
                    case "content":
                    case "author":
                        pstmt.setString(paramIndex++, keyword);
                        break;
                    case "all":
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
            System.out.println("SQL Error in getTotalCount: " + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return 0;
    }

    public int getTotalPostCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT COUNT(*) FROM Community";

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

    // 게시글 상세 조회
    public Community getCommunityById(int communityId, int currentUserId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT c.community_id, c.title, c.content, c.author_id, c.category, " +
                "c.created_at, c.updated_at, c.view_count, c.like_count, c.comment_count, " +
                "c.image_path, c.original_filename, " +
                "u.nickname as author_nickname, t.name as author_team_name, " +
                "CASE WHEN cl.user_id IS NOT NULL THEN TRUE ELSE FALSE END as is_liked " +
                "FROM community c " +
                "JOIN User u ON c.author_id = u.user_id " +
                "LEFT JOIN Team t ON u.team_id = t.team_id " +
                "LEFT JOIN community_likes cl ON c.community_id = cl.community_id AND cl.user_id = ? " +
                "WHERE c.community_id = ? AND c.is_deleted = FALSE";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, currentUserId);
            pstmt.setInt(2, communityId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                Community community = new Community();
                community.setCommunityId(rs.getInt("community_id"));
                community.setTitle(rs.getString("title"));
                community.setContent(rs.getString("content"));
                community.setAuthorId(rs.getInt("author_id"));
                community.setAuthorNickname(rs.getString("author_nickname"));
                community.setAuthorTeamName(rs.getString("author_team_name"));
                community.setCategory(rs.getString("category"));
                community.setCreatedAt(rs.getTimestamp("created_at"));
                community.setUpdatedAt(rs.getTimestamp("updated_at"));
                community.setViewCount(rs.getInt("view_count"));
                community.setLikeCount(rs.getInt("like_count"));
                community.setCommentCount(rs.getInt("comment_count"));
                community.setImagePath(rs.getString("image_path"));
                community.setOriginalFileName(rs.getString("original_filename"));
                community.setLikedByCurrentUser(rs.getBoolean("is_liked"));

                return community;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error in getCommunityById: " + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return null;
    }

    // 댓글 목록 조회
    public List<Community> getCommentsByCommunityId(int communityId, int currentUserId) {
        List<Community> comments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT c.comment_id, c.community_id, c.content, c.author_id, " +
                "c.created_at, c.updated_at, c.like_count, " +
                "u.nickname as author_nickname, t.name as author_team_name, " +
                "CASE WHEN cl.user_id IS NOT NULL THEN TRUE ELSE FALSE END as is_liked " +
                "FROM comments c " +
                "JOIN User u ON c.author_id = u.user_id " +
                "LEFT JOIN Team t ON u.team_id = t.team_id " +
                "LEFT JOIN comment_likes cl ON c.comment_id = cl.comment_id AND cl.user_id = ? " +
                "WHERE c.community_id = ? AND c.is_deleted = FALSE " +
                "ORDER BY c.created_at ASC";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, currentUserId);
            pstmt.setInt(2, communityId);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Community comment = new Community();
                comment.setCommentId(rs.getInt("comment_id"));
                comment.setCommunityId(rs.getInt("community_id"));
                comment.setCommentContent(rs.getString("content"));
                comment.setCommentAuthorId(rs.getInt("author_id"));
                comment.setCommentAuthorNickname(rs.getString("author_nickname"));
                comment.setCommentAuthorTeamName(rs.getString("author_team_name"));
                comment.setCommentCreatedAt(rs.getTimestamp("created_at"));
                comment.setCommentUpdatedAt(rs.getTimestamp("updated_at"));
                comment.setCommentLikeCount(rs.getInt("like_count"));
                comment.setCommentLikedByCurrentUser(rs.getBoolean("is_liked"));

                comments.add(comment);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error in getCommentsByCommunityId: " + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return comments;
    }

    // 조회수 증가
    public void incrementViewCount(int communityId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE community SET view_count = view_count + 1 WHERE community_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, communityId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // 게시글 작성
    public boolean createCommunity(Community community) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "INSERT INTO community (title, content, author_id, category, image_path, original_filename) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, community.getTitle());
            pstmt.setString(2, community.getContent());
            pstmt.setInt(3, community.getAuthorId());
            pstmt.setString(4, community.getCategory());
            pstmt.setString(5, community.getImagePath());
            pstmt.setString(6, community.getOriginalFileName());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }

        return false;
    }

    // 게시글 수정
    public boolean updateCommunity(Community community) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        // 이미지가 새로 업로드된 경우와 그렇지 않은 경우를 구분
        String sql;
        if (community.getImagePath() != null) {
            sql = "UPDATE community SET title = ?, content = ?, category = ?, image_path = ?, original_filename = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE community_id = ? AND author_id = ?";
        } else {
            sql = "UPDATE community SET title = ?, content = ?, category = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE community_id = ? AND author_id = ?";
        }

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, community.getTitle());
            pstmt.setString(2, community.getContent());
            pstmt.setString(3, community.getCategory());

            if (community.getImagePath() != null) {
                pstmt.setString(4, community.getImagePath());
                pstmt.setString(5, community.getOriginalFileName());
                pstmt.setInt(6, community.getCommunityId());
                pstmt.setInt(7, community.getAuthorId());
            } else {
                pstmt.setInt(4, community.getCommunityId());
                pstmt.setInt(5, community.getAuthorId());
            }

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }

        return false;
    }

    // 게시글 삭제 (소프트 삭제)
    public boolean deleteCommunity(int communityId, int authorId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE community SET is_deleted = TRUE WHERE community_id = ? AND author_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, communityId);
            pstmt.setInt(2, authorId);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }

        return false;
    }

    // 댓글 작성
    public boolean createComment(Community comment) {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 댓글 삽입
            String insertSql = "INSERT INTO comments (community_id, content, author_id) VALUES (?, ?, ?)";
            pstmt1 = conn.prepareStatement(insertSql);
            pstmt1.setInt(1, comment.getCommunityId());
            pstmt1.setString(2, comment.getCommentContent());
            pstmt1.setInt(3, comment.getCommentAuthorId());
            pstmt1.executeUpdate();

            // 게시글의 댓글 수 증가
            String updateSql = "UPDATE community SET comment_count = comment_count + 1 WHERE community_id = ?";
            pstmt2 = conn.prepareStatement(updateSql);
            pstmt2.setInt(1, comment.getCommunityId());
            pstmt2.executeUpdate();

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (pstmt1 != null) {
                try { pstmt1.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (pstmt2 != null) {
                try { pstmt2.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    // 댓글 삭제
    public boolean deleteComment(int commentId, int authorId) {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 댓글이 속한 게시글 ID 조회
            int communityId = 0;
            String selectSql = "SELECT community_id FROM comments WHERE comment_id = ? AND author_id = ?";
            pstmt1 = conn.prepareStatement(selectSql);
            pstmt1.setInt(1, commentId);
            pstmt1.setInt(2, authorId);
            rs = pstmt1.executeQuery();
            if (rs.next()) {
                communityId = rs.getInt("community_id");
            } else {
                return false; // 댓글이 없거나 권한이 없음
            }

            // 댓글 소프트 삭제
            String deleteSql = "UPDATE comments SET is_deleted = TRUE WHERE comment_id = ? AND author_id = ?";
            pstmt2 = conn.prepareStatement(deleteSql);
            pstmt2.setInt(1, commentId);
            pstmt2.setInt(2, authorId);
            pstmt2.executeUpdate();

            // 게시글의 댓글 수 감소
            String updateSql = "UPDATE community SET comment_count = comment_count - 1 WHERE community_id = ?";
            pstmt3 = conn.prepareStatement(updateSql);
            pstmt3.setInt(1, communityId);
            pstmt3.executeUpdate();

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            DBUtil.close(null, pstmt1, rs);
            if (pstmt2 != null) {
                try { pstmt2.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (pstmt3 != null) {
                try { pstmt3.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    // 게시글 좋아요 토글
    public boolean toggleCommunityLike(int communityId, int userId) {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 현재 좋아요 상태 확인
            boolean isLiked = false;
            String checkSql = "SELECT COUNT(*) FROM community_likes WHERE community_id = ? AND user_id = ?";
            pstmt1 = conn.prepareStatement(checkSql);
            pstmt1.setInt(1, communityId);
            pstmt1.setInt(2, userId);
            rs = pstmt1.executeQuery();
            if (rs.next()) {
                isLiked = rs.getInt(1) > 0;
            }

            if (isLiked) {
                // 좋아요 취소
                String deleteSql = "DELETE FROM community_likes WHERE community_id = ? AND user_id = ?";
                pstmt2 = conn.prepareStatement(deleteSql);
                pstmt2.setInt(1, communityId);
                pstmt2.setInt(2, userId);
                pstmt2.executeUpdate();

                String updateSql = "UPDATE community SET like_count = like_count - 1 WHERE community_id = ?";
                pstmt3 = conn.prepareStatement(updateSql);
                pstmt3.setInt(1, communityId);
                pstmt3.executeUpdate();
            } else {
                // 좋아요 추가
                String insertSql = "INSERT INTO community_likes (community_id, user_id) VALUES (?, ?)";
                pstmt2 = conn.prepareStatement(insertSql);
                pstmt2.setInt(1, communityId);
                pstmt2.setInt(2, userId);
                pstmt2.executeUpdate();

                String updateSql = "UPDATE community SET like_count = like_count + 1 WHERE community_id = ?";
                pstmt3 = conn.prepareStatement(updateSql);
                pstmt3.setInt(1, communityId);
                pstmt3.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            DBUtil.close(null, pstmt1, rs);
            if (pstmt2 != null) {
                try { pstmt2.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (pstmt3 != null) {
                try { pstmt3.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    // 댓글 좋아요 토글
    public boolean toggleCommentLike(int commentId, int userId) {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 현재 좋아요 상태 확인
            boolean isLiked = false;
            String checkSql = "SELECT COUNT(*) FROM comment_likes WHERE comment_id = ? AND user_id = ?";
            pstmt1 = conn.prepareStatement(checkSql);
            pstmt1.setInt(1, commentId);
            pstmt1.setInt(2, userId);
            rs = pstmt1.executeQuery();
            if (rs.next()) {
                isLiked = rs.getInt(1) > 0;
            }

            if (isLiked) {
                // 좋아요 취소
                String deleteSql = "DELETE FROM comment_likes WHERE comment_id = ? AND user_id = ?";
                pstmt2 = conn.prepareStatement(deleteSql);
                pstmt2.setInt(1, commentId);
                pstmt2.setInt(2, userId);
                pstmt2.executeUpdate();

                String updateSql = "UPDATE comments SET like_count = like_count - 1 WHERE comment_id = ?";
                pstmt3 = conn.prepareStatement(updateSql);
                pstmt3.setInt(1, commentId);
                pstmt3.executeUpdate();
            } else {
                // 좋아요 추가
                String insertSql = "INSERT INTO comment_likes (comment_id, user_id) VALUES (?, ?)";
                pstmt2 = conn.prepareStatement(insertSql);
                pstmt2.setInt(1, commentId);
                pstmt2.setInt(2, userId);
                pstmt2.executeUpdate();

                String updateSql = "UPDATE comments SET like_count = like_count + 1 WHERE comment_id = ?";
                pstmt3 = conn.prepareStatement(updateSql);
                pstmt3.setInt(1, commentId);
                pstmt3.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            DBUtil.close(null, pstmt1, rs);
            if (pstmt2 != null) {
                try { pstmt2.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (pstmt3 != null) {
                try { pstmt3.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    // 작성자 권한 확인
    public boolean isAuthor(int communityId, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM community WHERE community_id = ? AND author_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, communityId);
            pstmt.setInt(2, userId);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return false;
    }

    // 댓글 작성자 권한 확인
    public boolean isCommentAuthor(int commentId, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM comments WHERE comment_id = ? AND author_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentId);
            pstmt.setInt(2, userId);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return false;
    }
    // 관리자용 게시글 삭제 (작성자 확인 없이)
    public boolean adminDeleteCommunity(int communityId) {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. 댓글 좋아요 삭제
            String deleteCommentLikes = "DELETE cl FROM comment_likes cl " +
                    "JOIN comments c ON cl.comment_id = c.comment_id " +
                    "WHERE c.community_id = ?";
            pstmt1 = conn.prepareStatement(deleteCommentLikes);
            pstmt1.setInt(1, communityId);
            pstmt1.executeUpdate();

            // 2. 댓글 삭제 (소프트 삭제)
            String deleteComments = "UPDATE comments SET is_deleted = TRUE WHERE community_id = ?";
            pstmt2 = conn.prepareStatement(deleteComments);
            pstmt2.setInt(1, communityId);
            pstmt2.executeUpdate();

            // 3. 게시글 삭제 (소프트 삭제)
            String deleteCommunity = "UPDATE community SET is_deleted = TRUE WHERE community_id = ?";
            pstmt3 = conn.prepareStatement(deleteCommunity);
            pstmt3.setInt(1, communityId);
            int result = pstmt3.executeUpdate();

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

    // 관리자용 게시글 삭제 (하드 삭제)
    public boolean deletePostByAdmin(int communityId) {
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. 댓글 좋아요 삭제
            String deleteCommentLikes = "DELETE cl FROM comment_likes cl " +
                    "JOIN comments c ON cl.comment_id = c.comment_id " +
                    "WHERE c.community_id = ?";
            pstmt1 = conn.prepareStatement(deleteCommentLikes);
            pstmt1.setInt(1, communityId);
            pstmt1.executeUpdate();

            // 2. 게시글 좋아요 삭제
            String deleteCommunityLikes = "DELETE FROM community_likes WHERE community_id = ?";
            pstmt2 = conn.prepareStatement(deleteCommunityLikes);
            pstmt2.setInt(1, communityId);
            pstmt2.executeUpdate();

            // 3. 댓글 삭제
            String deleteComments = "DELETE FROM comments WHERE community_id = ?";
            pstmt3 = conn.prepareStatement(deleteComments);
            pstmt3.setInt(1, communityId);
            pstmt3.executeUpdate();

            // 4. 게시글 삭제
            String deleteCommunity = "DELETE FROM community WHERE community_id = ?";
            pstmt4 = conn.prepareStatement(deleteCommunity);
            pstmt4.setInt(1, communityId);
            int result = pstmt4.executeUpdate();

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