package com.kbofan.dto;

public class Team {
    private int teamId;
    private String name;
    private String logo;
    private String officialSite;
    private String primaryColor;
    private String secondaryColor;
    private int wins;
    private int losses;
    private int draws;
    private double winningPercentage;
    private int rank;
    private double gamesBehind;
    private int foundedYear;
    private String description;
    private String long_description;
    private String stadium_name;
    private double stadium_lat;
    private double stadium_lng;
    private int championships;
    private String championshipYears;

    // Getters and Setters
    public int getTeamId() {
        return teamId;
    }

    public void setTeamId(int teamId) {
        this.teamId = teamId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getOfficialSite() {
        return officialSite;
    }

    public void setOfficialSite(String officialSite) {
        this.officialSite = officialSite;
    }

    public String getPrimaryColor() {
        return primaryColor;
    }

    public void setPrimaryColor(String primaryColor) {
        this.primaryColor = primaryColor;
    }

    public String getSecondaryColor() {
        return secondaryColor;
    }

    public void setSecondaryColor(String secondaryColor) {
        this.secondaryColor = secondaryColor;
    }

    public int getWins() {
        return wins;
    }

    public void setWins(int wins) {
        this.wins = wins;
    }

    public int getLosses() {
        return losses;
    }

    public void setLosses(int losses) {
        this.losses = losses;
    }

    public int getDraws() {
        return draws;
    }

    public void setDraws(int draws) {
        this.draws = draws;
    }

    public double getWinningPercentage() {
        return winningPercentage;
    }

    public void setWinningPercentage(double winningPercentage) {
        this.winningPercentage = winningPercentage;
    }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public double getGamesBehind() {
        return gamesBehind;
    }

    public void setGamesBehind(double gamesBehind) {
        this.gamesBehind = gamesBehind;
    }

    // 승률 계산 메서드
    public void calculateWinningPercentage() {
        if (wins + losses + draws > 0) {
            // 무승부는 0.5승 0.5패로 계산
            double effectiveWins = wins + (draws * 0.5);
            double effectiveGames = wins + losses + draws;
            this.winningPercentage = effectiveWins / effectiveGames;
        } else {
            this.winningPercentage = 0.0;
        }
    }

    public int getFoundedYear() {
        return foundedYear;
    }

    public void setFoundedYear(int foundedYear) {
        this.foundedYear = foundedYear;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLong_description() {
            return long_description;
    }

    public void setLong_description(String long_description) {
            this.long_description = long_description;
    }

    public String getStadium_name() {
        return stadium_name;
    }

    public void setStadium_name(String stadium_name) {
        this.stadium_name = stadium_name;
    }

    public double getStadium_lat() {
        return stadium_lat;
    }

    public void setStadium_lat(double stadium_lat) {
        this.stadium_lat = stadium_lat;
    }

    public double getStadium_lng() {
        return stadium_lng;
    }

    public void setStadium_lng(double stadium_lng) {
        this.stadium_lng = stadium_lng;
    }

    public int getChampionships() {
        return championships;
    }

    public void setChampionships(int championships) {
        this.championships = championships;
    }

    public String getChampionshipYears() {
        return championshipYears;
    }

    public void setChampionshipYears(String championshipYears) {
        this.championshipYears = championshipYears;
    }
}
