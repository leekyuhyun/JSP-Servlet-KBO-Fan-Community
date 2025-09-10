package com.kbofan.dto;

import java.util.Date;

public class Game {
    private int gameId;
    private Date gameDate;
    private String gameTime;
    private String stadium;
    private int awayTeam;
    private int homeTeam;
    private Integer awayScore;
    private Integer homeScore;
    private String awayPitcher;
    private String awayPitcherResult;
    private String homePitcher;
    private String homePitcherResult;
    private String winner;
    private String awayTeamName;
    private String homeTeamName;
    private String awayTeamLogo;
    private String homeTeamLogo;
    private String status;
    private String etc;

    // Getters and Setters
    public int getGameId() {
        return gameId;
    }

    public void setGameId(int gameId) {
        this.gameId = gameId;
    }

    public Date getGameDate() {
        return gameDate;
    }

    public void setGameDate(Date gameDate) {
        this.gameDate = gameDate;
    }

    public String getGameTime() {
        return gameTime;
    }

    public void setGameTime(String gameTime) {
        this.gameTime = gameTime;
    }

    public String getStadium() {
        return stadium;
    }

    public void setStadium(String stadium) {
        this.stadium = stadium;
    }

    public int getAwayTeam() {
        return awayTeam;
    }

    public void setAwayTeam(int awayTeam) {
        this.awayTeam = awayTeam;
    }

    public int getHomeTeam() {
        return homeTeam;
    }

    public void setHomeTeam(int homeTeam) {
        this.homeTeam = homeTeam;
    }

    public Integer getAwayScore() {
        return awayScore;
    }

    public void setAwayScore(Integer awayScore) {
        this.awayScore = awayScore;
    }

    public Integer getHomeScore() {
        return homeScore;
    }

    public void setHomeScore(Integer homeScore) {
        this.homeScore = homeScore;
    }

    public String getAwayPitcher() {
        return awayPitcher;
    }

    public void setAwayPitcher(String awayPitcher) {
        this.awayPitcher = awayPitcher;
    }

    public String getAwayPitcherResult() {
        return awayPitcherResult;
    }

    public void setAwayPitcherResult(String awayPitcherResult) {
        this.awayPitcherResult = awayPitcherResult;
    }

    public String getHomePitcher() {
        return homePitcher;
    }

    public void setHomePitcher(String homePitcher) {
        this.homePitcher = homePitcher;
    }

    public String getHomePitcherResult() {
        return homePitcherResult;
    }

    public void setHomePitcherResult(String homePitcherResult) {
        this.homePitcherResult = homePitcherResult;
    }

    public String getWinner() {
        return winner;
    }

    public void setWinner(String winner) {
        this.winner = winner;
    }

    public String getAwayTeamName() {
        return awayTeamName;
    }

    public void setAwayTeamName(String awayTeamName) {
        this.awayTeamName = awayTeamName;
    }

    public String getHomeTeamName() {
        return homeTeamName;
    }

    public void setHomeTeamName(String homeTeamName) {
        this.homeTeamName = homeTeamName;
    }

    public String getAwayTeamLogo() {
        return awayTeamLogo;
    }

    public void setAwayTeamLogo(String awayTeamLogo) {
        this.awayTeamLogo = awayTeamLogo;
    }

    public String getHomeTeamLogo() {
        return homeTeamLogo;
    }

    public void setHomeTeamLogo(String homeTeamLogo) {
        this.homeTeamLogo = homeTeamLogo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEtc() {
        return etc;
    }

    public void setEtc(String etc) {
        this.etc = etc;
    }

    // 경기 상태에 따른 편의 메서드
    public boolean isCompleted() {
        return "COMPLETED".equals(status);
    }

    public boolean isScheduled() {
        return "SCHEDULED".equals(status);
    }

    public boolean isCanceled() {
        return "CANCELED".equals(status);
    }

    // 점수 표시를 위한 편의 메서드
    public String getScoreDisplay() {
        if (isCompleted()) {
            return awayScore + " - " + homeScore;
        } else if (isCanceled()) {
            return "경기 취소";
        } else {
            return "vs";
        }
    }
}
