package com.kbofan.dto;

import java.sql.Date;
import java.sql.Timestamp;

public class GameRecord {
    private int recordId;
    private int userId;
    private Date gameDate;
    private String stadium;
    private String homeTeam;
    private String awayTeam;
    private int homeScore;
    private int awayScore;
    private String seat;
    private String memo;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public GameRecord() {}

    // Getters and Setters
    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getGameDate() { return gameDate; }
    public void setGameDate(Date gameDate) { this.gameDate = gameDate; }

    public String getStadium() { return stadium; }
    public void setStadium(String stadium) { this.stadium = stadium; }

    public String getHomeTeam() { return homeTeam; }
    public void setHomeTeam(String homeTeam) { this.homeTeam = homeTeam; }

    public String getAwayTeam() { return awayTeam; }
    public void setAwayTeam(String awayTeam) { this.awayTeam = awayTeam; }

    public int getHomeScore() { return homeScore; }
    public void setHomeScore(int homeScore) { this.homeScore = homeScore; }

    public int getAwayScore() { return awayScore; }
    public void setAwayScore(int awayScore) { this.awayScore = awayScore; }

    public String getSeat() { return seat; }
    public void setSeat(String seat) { this.seat = seat; }

    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // 유틸리티 메소드
    public String getWinner() {
        if (homeScore > awayScore) {
            return homeTeam;
        } else if (awayScore > homeScore) {
            return awayTeam;
        } else {
            return "무승부";
        }
    }

    public boolean isWin() {
        return !getWinner().equals("무승부");
    }
}
