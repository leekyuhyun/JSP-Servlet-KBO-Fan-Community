package com.kbofan.dto;

public class User {
    private int userId;
    private String username;
    private String loginId;
    private String nickname;
    private String password;
    private String email;
    private int teamId;
    private String teamName;
    private String teamLogo;
    private String teamPrimaryColor;
    private String teamSecondaryColor;
    private boolean admin = false;

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getTeamId() {
        return teamId;
    }

    public void setTeamId(int teamId) {
        this.teamId = teamId;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getTeamLogo() {
        return teamLogo;
    }

    public void setTeamLogo(String teamLogo) {
        this.teamLogo = teamLogo;
    }

    public String getTeamPrimaryColor() {
        return teamPrimaryColor;
    }

    public void setTeamPrimaryColor(String teamPrimaryColor) {
        this.teamPrimaryColor = teamPrimaryColor;
    }

    public String getTeamSecondaryColor() {
        return teamSecondaryColor;
    }

    public void setTeamSecondaryColor(String teamSecondaryColor) {
        this.teamSecondaryColor = teamSecondaryColor;
    }

    public boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean isAdmin) {
        this.admin = isAdmin;
    }
}
