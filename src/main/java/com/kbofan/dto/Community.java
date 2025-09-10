package com.kbofan.dto;

import java.sql.Timestamp;
import java.util.List;

public class Community {
    // 커뮤니티 게시글 필드
    private int communityId;
    private String title;
    private String content;
    private int authorId;
    private String authorNickname;
    private String authorTeamName;
    private String category;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private int viewCount;
    private int likeCount;
    private int commentCount;
    private boolean isDeleted;

    // 이미지 관련 필드 추가
    private String imagePath;
    private String originalFileName;

    // 댓글 관련 필드
    private int commentId;
    private String commentContent;
    private int commentAuthorId;
    private String commentAuthorNickname;
    private String commentAuthorTeamName;
    private Timestamp commentCreatedAt;
    private Timestamp commentUpdatedAt;
    private int commentLikeCount;
    private boolean commentDeleted;

    // 좋아요 관련 필드
    private boolean isLikedByCurrentUser;
    private boolean isCommentLikedByCurrentUser;

    // 댓글 목록 (게시글 상세보기에서 사용)
    private List<Community> comments;

    // 기본 생성자
    public Community() {}

    // 게시글 생성자
    public Community(String title, String content, int authorId, String category) {
        this.title = title;
        this.content = content;
        this.authorId = authorId;
        this.category = category;
    }

    // 댓글 생성자
    public Community(int communityId, String commentContent, int commentAuthorId) {
        this.communityId = communityId;
        this.commentContent = commentContent;
        this.commentAuthorId = commentAuthorId;
    }

    // Getter and Setter methods
    public int getCommunityId() {
        return communityId;
    }

    public void setCommunityId(int communityId) {
        this.communityId = communityId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public String getAuthorNickname() {
        return authorNickname;
    }

    public void setAuthorNickname(String authorNickname) {
        this.authorNickname = authorNickname;
    }

    public String getAuthorTeamName() {
        return authorTeamName;
    }

    public void setAuthorTeamName(String authorTeamName) {
        this.authorTeamName = authorTeamName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    // 이미지 관련 getter/setter
    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getOriginalFileName() {
        return originalFileName;
    }

    public void setOriginalFileName(String originalFileName) {
        this.originalFileName = originalFileName;
    }

    // 댓글 관련 getter/setter
    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public String getCommentContent() {
        return commentContent;
    }

    public void setCommentContent(String commentContent) {
        this.commentContent = commentContent;
    }

    public int getCommentAuthorId() {
        return commentAuthorId;
    }

    public void setCommentAuthorId(int commentAuthorId) {
        this.commentAuthorId = commentAuthorId;
    }

    public String getCommentAuthorNickname() {
        return commentAuthorNickname;
    }

    public void setCommentAuthorNickname(String commentAuthorNickname) {
        this.commentAuthorNickname = commentAuthorNickname;
    }

    public String getCommentAuthorTeamName() {
        return commentAuthorTeamName;
    }

    public void setCommentAuthorTeamName(String commentAuthorTeamName) {
        this.commentAuthorTeamName = commentAuthorTeamName;
    }

    public Timestamp getCommentCreatedAt() {
        return commentCreatedAt;
    }

    public void setCommentCreatedAt(Timestamp commentCreatedAt) {
        this.commentCreatedAt = commentCreatedAt;
    }

    public Timestamp getCommentUpdatedAt() {
        return commentUpdatedAt;
    }

    public void setCommentUpdatedAt(Timestamp commentUpdatedAt) {
        this.commentUpdatedAt = commentUpdatedAt;
    }

    public int getCommentLikeCount() {
        return commentLikeCount;
    }

    public void setCommentLikeCount(int commentLikeCount) {
        this.commentLikeCount = commentLikeCount;
    }

    public boolean isCommentDeleted() {
        return commentDeleted;
    }

    public void setCommentDeleted(boolean commentDeleted) {
        this.commentDeleted = commentDeleted;
    }

    // 좋아요 관련 getter/setter
    public boolean isLikedByCurrentUser() {
        return isLikedByCurrentUser;
    }

    public void setLikedByCurrentUser(boolean likedByCurrentUser) {
        isLikedByCurrentUser = likedByCurrentUser;
    }

    public boolean isCommentLikedByCurrentUser() {
        return isCommentLikedByCurrentUser;
    }

    public void setCommentLikedByCurrentUser(boolean commentLikedByCurrentUser) {
        isCommentLikedByCurrentUser = commentLikedByCurrentUser;
    }

    public List<Community> getComments() {
        return comments;
    }

    public void setComments(List<Community> comments) {
        this.comments = comments;
    }

    // 유틸리티 메서드
    public String getCategoryDisplayName() {
        switch (category) {
            case "free": return "자유게시판";
            case "analysis": return "경기분석";
            case "news": return "뉴스/소식";
            case "humor": return "유머";
            case "question": return "질문";
            case "trade": return "트레이드";
            default: return "기타";
        }
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";

        long now = System.currentTimeMillis();
        long postTime = createdAt.getTime();
        long diff = now - postTime;

        if (diff < 60000) { // 1분 미만
            return "방금 전";
        } else if (diff < 3600000) { // 1시간 미만
            return (diff / 60000) + "분 전";
        } else if (diff < 86400000) { // 24시간 미만
            return (diff / 3600000) + "시간 전";
        } else if (diff < 604800000) { // 7일 미만
            return (diff / 86400000) + "일 전";
        } else {
            return createdAt.toString().substring(0, 10); // YYYY-MM-DD 형식
        }
    }

    public String getFormattedCommentCreatedAt() {
        if (commentCreatedAt == null) return "";

        long now = System.currentTimeMillis();
        long commentTime = commentCreatedAt.getTime();
        long diff = now - commentTime;

        if (diff < 60000) { // 1분 미만
            return "방금 전";
        } else if (diff < 3600000) { // 1시간 미만
            return (diff / 60000) + "분 전";
        } else if (diff < 86400000) { // 24시간 미만
            return (diff / 3600000) + "시간 전";
        } else {
            return commentCreatedAt.toString().substring(0, 16); // YYYY-MM-DD HH:MM 형식
        }
    }

    @Override
    public String toString() {
        return "Community{" +
                "communityId=" + communityId +
                ", title='" + title + '\'' +
                ", authorNickname='" + authorNickname + '\'' +
                ", category='" + category + '\'' +
                ", createdAt=" + createdAt +
                ", viewCount=" + viewCount +
                ", likeCount=" + likeCount +
                ", commentCount=" + commentCount +
                ", imagePath='" + imagePath + '\'' +
                '}';
    }
}