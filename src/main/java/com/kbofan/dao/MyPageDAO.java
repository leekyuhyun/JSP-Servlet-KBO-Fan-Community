package com.kbofan.dao;

import com.kbofan.dto.Community;
import com.kbofan.dto.GameRecord;
import com.kbofan.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MyPageDAO {

    // 사용자가 작성한 게시글 조회
    public List<Community> getUserPosts(int userId, int limit) {
        List<Community> posts = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT c.community_id, c.title, c.content, c.author_id, c.category, " +
                "c.created_at, c.updated_at, c.view_count, c.like_count, c.comment_count, " +
                "u.nickname as author_nickname, t.name as author_team_name " +
                "FROM community c " +
                "JOIN User u ON c.author_id = u.user_id " +
                "LEFT JOIN Team t ON u.team_id = t.team_id " +
                "WHERE c.author_id = ? AND c.is_deleted = FALSE " +
                "ORDER BY c.created_at DESC";

        if (limit > 0) {
            sql += " LIMIT ?";
        }

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            if (limit > 0) {
                pstmt.setInt(2, limit);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Community post = new Community();
                post.setCommunityId(rs.getInt("community_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setAuthorId(rs.getInt("author_id"));
                post.setAuthorNickname(rs.getString("author_nickname"));
                post.setAuthorTeamName(rs.getString("author_team_name"));
                post.setCategory(rs.getString("category"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setUpdatedAt(rs.getTimestamp("updated_at"));
                post.setViewCount(rs.getInt("view_count"));
                post.setLikeCount(rs.getInt("like_count"));
                post.setCommentCount(rs.getInt("comment_count"));

                posts.add(post);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return posts;
    }

    // 사용자가 좋아요한 게시글 조회
    public List<Community> getLikedPosts(int userId, int limit) {
        List<Community> posts = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT c.community_id, c.title, c.content, c.author_id, c.category, " +
                "c.created_at, c.updated_at, c.view_count, c.like_count, c.comment_count, " +
                "u.nickname as author_nickname, t.name as author_team_name, cl.created_at as liked_at " +
                "FROM community c " +
                "JOIN community_likes cl ON c.community_id = cl.community_id " +
                "JOIN User u ON c.author_id = u.user_id " +
                "LEFT JOIN Team t ON u.team_id = t.team_id " +
                "WHERE cl.user_id = ? AND c.is_deleted = FALSE " +
                "ORDER BY cl.created_at DESC";

        if (limit > 0) {
            sql += " LIMIT ?";
        }

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            if (limit > 0) {
                pstmt.setInt(2, limit);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Community post = new Community();
                post.setCommunityId(rs.getInt("community_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setAuthorId(rs.getInt("author_id"));
                post.setAuthorNickname(rs.getString("author_nickname"));
                post.setAuthorTeamName(rs.getString("author_team_name"));
                post.setCategory(rs.getString("category"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setUpdatedAt(rs.getTimestamp("updated_at"));
                post.setViewCount(rs.getInt("view_count"));
                post.setLikeCount(rs.getInt("like_count"));
                post.setCommentCount(rs.getInt("comment_count"));
                post.setLikedByCurrentUser(true);

                posts.add(post);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return posts;
    }

    // 사용자가 작성한 댓글 조회
    public List<Community> getUserComments(int userId, int limit) {
        List<Community> comments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT cm.comment_id, cm.content, cm.created_at, cm.updated_at, cm.like_count, " +
                "cm.community_id, c.title, c.author_id as post_author_id, " +
                "u.nickname as comment_author_nickname, t.name as comment_author_team_name, " +
                "pu.nickname as post_author_nickname " +
                "FROM comments cm " +
                "JOIN community c ON cm.community_id = c.community_id " +
                "JOIN User u ON cm.author_id = u.user_id " +
                "LEFT JOIN Team t ON u.team_id = t.team_id " +
                "JOIN User pu ON c.author_id = pu.user_id " +
                "WHERE cm.author_id = ? AND cm.is_deleted = FALSE AND c.is_deleted = FALSE " +
                "ORDER BY cm.created_at DESC";

        if (limit > 0) {
            sql += " LIMIT ?";
        }

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            if (limit > 0) {
                pstmt.setInt(2, limit);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Community comment = new Community();
                comment.setCommentId(rs.getInt("comment_id"));
                comment.setCommentContent(rs.getString("content"));
                comment.setCommentCreatedAt(rs.getTimestamp("created_at"));
                comment.setCommentLikeCount(rs.getInt("like_count"));
                comment.setCommunityId(rs.getInt("community_id"));
                comment.setTitle(rs.getString("title"));
                comment.setCommentAuthorId(userId);
                comment.setCommentAuthorNickname(rs.getString("comment_author_nickname"));
                comment.setAuthorNickname(rs.getString("post_author_nickname"));

                comments.add(comment);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return comments;
    }

    // 사용자 활동 통계 조회
    public int[] getUserActivityStats(int userId) {
        int[] stats = new int[3]; // [게시글 수, 댓글 수, 직관 기록 수]
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            // 게시글 수 조회
            String postSql = "SELECT COUNT(*) FROM community WHERE author_id = ? AND is_deleted = FALSE";
            pstmt = conn.prepareStatement(postSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stats[0] = rs.getInt(1);
            }
            rs.close();
            pstmt.close();

            // 댓글 수 조회
            String commentSql = "SELECT COUNT(*) FROM comments WHERE author_id = ? AND is_deleted = FALSE";
            pstmt = conn.prepareStatement(commentSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stats[1] = rs.getInt(1);
            }
            rs.close();
            pstmt.close();

            // 직관 기록 수 조회
            String gameSql = "SELECT COUNT(*) FROM game_records WHERE user_id = ?";
            pstmt = conn.prepareStatement(gameSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stats[2] = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return stats;
    }

    // 사용자의 직관 기록 조회
    public List<GameRecord> getUserGameRecords(int userId, int limit) {
        List<GameRecord> records = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM game_records WHERE user_id = ? ORDER BY game_date DESC";
        if (limit > 0) {
            sql += " LIMIT ?";
        }

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            if (limit > 0) {
                pstmt.setInt(2, limit);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                GameRecord record = new GameRecord();
                record.setRecordId(rs.getInt("record_id"));
                record.setUserId(rs.getInt("user_id"));
                record.setGameDate(rs.getDate("game_date"));
                record.setStadium(rs.getString("stadium"));
                record.setHomeTeam(rs.getString("home_team"));
                record.setAwayTeam(rs.getString("away_team"));
                record.setHomeScore(rs.getInt("home_score"));
                record.setAwayScore(rs.getInt("away_score"));
                record.setSeat(rs.getString("seat"));
                record.setMemo(rs.getString("memo"));
                record.setCreatedAt(rs.getTimestamp("created_at"));
                record.setUpdatedAt(rs.getTimestamp("updated_at"));

                records.add(record);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return records;
    }

    // 직관 기록 추가
    public boolean addGameRecord(GameRecord record) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "INSERT INTO game_records (user_id, game_date, stadium, home_team, away_team, " +
                "home_score, away_score, seat, memo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, record.getUserId());
            pstmt.setDate(2, record.getGameDate());
            pstmt.setString(3, record.getStadium());
            pstmt.setString(4, record.getHomeTeam());
            pstmt.setString(5, record.getAwayTeam());
            pstmt.setInt(6, record.getHomeScore());
            pstmt.setInt(7, record.getAwayScore());
            pstmt.setString(8, record.getSeat());
            pstmt.setString(9, record.getMemo());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }

    // 직관 기록 삭제
    public boolean deleteGameRecord(int recordId, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "DELETE FROM game_records WHERE record_id = ? AND user_id = ?";

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recordId);
            pstmt.setInt(2, userId);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt);
        }
    }
}
