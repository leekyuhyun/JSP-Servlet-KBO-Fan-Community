package com.kbofan.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.kbofan.dao.TeamDAO;
import com.kbofan.dao.UserDAO;
import com.kbofan.dto.Team;
import com.kbofan.dto.User;

/**
 * RegisterServlet
 * - 회원가입 요청을 처리하는 서블릿
 * - GET 요청 시 팀 목록과 함께 회원가입 폼을 보여주고,
 * - POST 요청 시 회원가입 데이터를 검증하고 DB에 저장함
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * 회원가입 폼 표시 (GET 요청 처리)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 팀 목록 조회 (응원팀 선택용)
        TeamDAO teamDAO = new TeamDAO();
        List<Team> teams = teamDAO.getAllTeams();
        request.setAttribute("teams", teams);

        // register.jsp로 포워드
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    /**
     * 회원가입 처리 (POST 요청)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 한글 인코딩 설정
        request.setCharacterEncoding("UTF-8");

        // 폼에서 전송된 사용자 입력값 가져오기
        String username = request.getParameter("username");
        String loginId = request.getParameter("loginId");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String teamIdStr = request.getParameter("teamId");

        // 입력값 검증: 비어 있는 값이 있는지 확인
        if (username == null || username.trim().isEmpty() ||
                loginId == null || loginId.trim().isEmpty() ||
                nickname == null || nickname.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                teamIdStr == null || teamIdStr.trim().isEmpty()) {

            // 에러 메시지를 설정하고 다시 폼 페이지로 이동
            request.setAttribute("errorMessage", "모든 필드를 입력해주세요.");
            doGet(request, response);
            return;
        }

        // 비밀번호 확인
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            doGet(request, response);
            return;
        }

        // 아이디 중복 확인
        UserDAO userDAO = new UserDAO();
        if (!userDAO.isLoginIdAvailable(loginId)) {
            request.setAttribute("errorMessage", "이미 사용 중인 아이디입니다.");
            doGet(request, response);
            return;
        }

        // User DTO 객체 생성 및 값 설정
        User user = new User();
        user.setUsername(username);
        user.setLoginId(loginId);
        user.setNickname(nickname);
        user.setPassword(password); // 실제 서비스에서는 해싱해야 함
        user.setEmail(email);
        user.setTeamId(Integer.parseInt(teamIdStr)); // 문자열을 int로 변환

        // DB에 사용자 등록
        boolean success = userDAO.registerUser(user);

        if (success) {
            // 성공 메시지를 설정하고 로그인 페이지로 이동
            request.setAttribute("successMessage", "회원가입이 완료되었습니다. 로그인해주세요.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // 실패 시 에러 메시지를 설정하고 다시 폼 페이지로 이동
            request.setAttribute("errorMessage", "회원가입 중 오류가 발생했습니다. 다시 시도해주세요.");
            doGet(request, response);
        }
    }
}
