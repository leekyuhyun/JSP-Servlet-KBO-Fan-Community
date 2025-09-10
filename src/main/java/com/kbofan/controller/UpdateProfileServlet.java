package com.kbofan.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.kbofan.dao.TeamDAO;
import com.kbofan.dao.UserDAO;
import com.kbofan.dto.Team;
import com.kbofan.dto.User;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 로그인 체크
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        System.out.println("UpdateProfile doGet - User from session: " + currentUser);
        System.out.println("User ID: " + (currentUser != null ? currentUser.getUserId() : "null"));
        System.out.println("Username: " + (currentUser != null ? currentUser.getUsername() : "null"));

        // 최신 사용자 정보를 DB에서 다시 조회
        if (currentUser != null) {
            UserDAO userDAO = new UserDAO();
            User refreshedUser = userDAO.getUserByLoginId(currentUser.getLoginId());

            if (refreshedUser != null) {
                currentUser = refreshedUser;
                // 세션도 업데이트
                session.setAttribute("user", refreshedUser);
                System.out.println("Refreshed user info from DB");
            }
        }

        // 팀 목록 가져오기
        try {
            TeamDAO teamDAO = new TeamDAO();
            List<Team> teams = teamDAO.getAllTeams();
            request.setAttribute("teams", teams);
            System.out.println("Teams loaded: " + (teams != null ? teams.size() : "null"));
        } catch (Exception e) {
            System.out.println("Error loading teams: " + e.getMessage());
            e.printStackTrace();
        }

        // 현재 사용자 정보를 request에 설정
        request.setAttribute("currentUser", currentUser);
        System.out.println("Set currentUser in request: " + currentUser);

        request.getRequestDispatcher("updateProfile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 로그인 체크
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        // 폼 데이터 가져오기
        String username = request.getParameter("username");
        String nickname = request.getParameter("nickname");
        String email = request.getParameter("email");
        String teamIdStr = request.getParameter("teamId");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        System.out.println("Form data received:");
        System.out.println("Username: " + username);
        System.out.println("Nickname: " + nickname);
        System.out.println("Email: " + email);
        System.out.println("TeamId: " + teamIdStr);

        // 입력 검증
        if (username == null || username.trim().isEmpty() ||
                nickname == null || nickname.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                teamIdStr == null || teamIdStr.trim().isEmpty()) {

            request.setAttribute("errorMessage", "필수 필드를 모두 입력해주세요.");
            doGet(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();

        // 현재 비밀번호 확인 (비밀번호 변경 시에만)
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                request.setAttribute("errorMessage", "현재 비밀번호를 입력해주세요.");
                doGet(request, response);
                return;
            }

            // 현재 비밀번호 검증
            User validUser = userDAO.validateLogin(currentUser.getLoginId(), currentPassword);
            if (validUser == null) {
                request.setAttribute("errorMessage", "현재 비밀번호가 일치하지 않습니다.");
                doGet(request, response);
                return;
            }

            // 새 비밀번호 확인
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "새 비밀번호가 일치하지 않습니다.");
                doGet(request, response);
                return;
            }
        }

        // 사용자 정보 업데이트
        User updateUser = new User();
        updateUser.setUserId(currentUser.getUserId());
        updateUser.setUsername(username);
        updateUser.setNickname(nickname);
        updateUser.setEmail(email);
        updateUser.setTeamId(Integer.parseInt(teamIdStr));

        // 비밀번호 변경이 있는 경우
        boolean updatePassword = newPassword != null && !newPassword.trim().isEmpty();
        if (updatePassword) {
            updateUser.setPassword(newPassword);
        }

        boolean success = userDAO.updateUser(updateUser, updatePassword);

        if (success) {
            // 세션의 사용자 정보 업데이트
            User updatedUser = userDAO.getUserByLoginId(currentUser.getLoginId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
                request.setAttribute("currentUser", updatedUser);
            }

            request.setAttribute("successMessage", "회원정보가 성공적으로 수정되었습니다.");
            System.out.println("User info updated successfully");
        } else {
            request.setAttribute("errorMessage", "회원정보 수정 중 오류가 발생했습니다.");
            System.out.println("Failed to update user info");
        }

        doGet(request, response);
    }
}