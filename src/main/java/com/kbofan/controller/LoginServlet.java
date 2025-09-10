package com.kbofan.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.kbofan.dao.UserDAO;
import com.kbofan.dto.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 이미 로그인된 사용자는 적절한 페이지로 리다이렉트
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            // 관리자인 경우 관리자 대시보드로 리다이렉트
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else {
                // 일반 사용자는 메인 페이지로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/main.jsp");
            }
            return;
        }

        // 로그인 페이지로 포워드
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String loginId = request.getParameter("loginId");
        String password = request.getParameter("password");

        // 디버깅 로그 추가
        System.out.println("로그인 시도: " + loginId);

        // 입력 검증
        if (loginId == null || loginId.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "아이디와 비밀번호를 모두 입력해주세요.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // admin/admin 특별 처리
        if ("admin".equals(loginId) && "admin".equals(password)) {
            try {
                System.out.println("=== 관리자 로그인 디버깅 시작 ===");

                // 관리자 사용자 객체 생성
                User adminUser = new User();
                adminUser.setUserId(0);
                adminUser.setUsername("관리자");
                adminUser.setLoginId("admin");
                adminUser.setNickname("관리자");
                adminUser.setEmail("admin@example.com");
                adminUser.setTeamId(0);
                adminUser.setTeamName("");
                adminUser.setTeamLogo("");
                adminUser.setTeamPrimaryColor("#343a40");
                adminUser.setTeamSecondaryColor("#f8f9fa");

                // 관리자 권한 설정 전후 확인
                System.out.println("setAdmin 호출 전: " + adminUser.isAdmin());
                adminUser.setAdmin(true);
                System.out.println("setAdmin 호출 후: " + adminUser.isAdmin());

                // 세션에 저장
                HttpSession session = request.getSession();
                session.setAttribute("user", adminUser);

                // 세션에서 다시 가져와서 확인
                User sessionUser = (User) session.getAttribute("user");
                System.out.println("세션에서 가져온 사용자: " + sessionUser.getLoginId());
                System.out.println("세션 사용자 isAdmin: " + sessionUser.isAdmin());

                // 리다이렉트 전 최종 확인
                if (sessionUser.isAdmin()) {
                    System.out.println("관리자로 인식됨 - 대시보드로 리다이렉트");
                    response.sendRedirect(request.getContextPath() + "/admin?action=dashboard.jsp");
                } else {
                    System.out.println("일반 사용자로 인식됨 - main.jsp로 리다이렉트");
                    response.sendRedirect(request.getContextPath() + "/main.jsp");
                }
                return;

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "관리자 로그인 처리 중 오류: " + e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
        }

        // 일반 로그인 처리
        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.validateLogin(loginId, password);

            if (user != null) {
                // 로그인 성공
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                // 디버깅 로그 추가
                System.out.println("일반 사용자 로그인 성공: isAdmin=" + user.isAdmin());

                // 관리자인 경우 관리자 대시보드로 리다이렉트
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                } else {
                    // 일반 사용자는 메인 페이지로 리다이렉트
                    response.sendRedirect(request.getContextPath() + "/main.jsp");
                }
            } else {
                // 로그인 실패
                System.out.println("로그인 실패: " + loginId);
                request.setAttribute("errorMessage", "아이디 또는 비밀번호가 일치하지 않습니다.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // 오류 로깅
            e.printStackTrace();
            request.setAttribute("errorMessage", "로그인 처리 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}