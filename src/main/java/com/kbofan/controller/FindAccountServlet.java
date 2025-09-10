package com.kbofan.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.kbofan.dao.UserDAO;
import com.kbofan.dto.User;

@WebServlet("/findAccount")
public class FindAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");

        if ("id".equals(type)) {
            request.setAttribute("findType", "id");
            request.setAttribute("pageTitle", "아이디 찾기");
        } else if ("password".equals(type)) {
            request.setAttribute("findType", "password");
            request.setAttribute("pageTitle", "비밀번호 찾기");
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("findAccount.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String type = request.getParameter("type");
        UserDAO userDAO = new UserDAO();

        if ("id".equals(type)) {
            // 아이디 찾기
            String username = request.getParameter("username");
            String email = request.getParameter("email");

            if (username == null || username.trim().isEmpty() ||
                    email == null || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "이름과 이메일을 모두 입력해주세요.");
                request.setAttribute("findType", "id");
                request.setAttribute("pageTitle", "아이디 찾기");
                request.getRequestDispatcher("findAccount.jsp").forward(request, response);
                return;
            }

            String foundId = userDAO.findLoginIdByNameAndEmail(username, email);

            if (foundId != null) {
                request.setAttribute("successMessage", "찾은 아이디: " + foundId);
            } else {
                request.setAttribute("errorMessage", "입력하신 정보와 일치하는 아이디를 찾을 수 없습니다.");
            }

            request.setAttribute("findType", "id");
            request.setAttribute("pageTitle", "아이디 찾기");

        } else if ("password".equals(type)) {
            // 비밀번호 찾기 (임시 비밀번호 발급)
            String loginId = request.getParameter("loginId");
            String email = request.getParameter("email");

            if (loginId == null || loginId.trim().isEmpty() ||
                    email == null || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "아이디와 이메일을 모두 입력해주세요.");
                request.setAttribute("findType", "password");
                request.setAttribute("pageTitle", "비밀번호 찾기");
                request.getRequestDispatcher("findAccount.jsp").forward(request, response);
                return;
            }

            User user = userDAO.findUserByLoginIdAndEmail(loginId, email);

            if (user != null) {
                // 임시 비밀번호 생성 및 업데이트
                String tempPassword = generateTempPassword();
                boolean updated = userDAO.updatePassword(user.getUserId(), tempPassword);

                if (updated) {
                    request.setAttribute("successMessage",
                            "임시 비밀번호가 발급되었습니다: " + tempPassword +
                                    "<br>로그인 후 반드시 비밀번호를 변경해주세요.");
                } else {
                    request.setAttribute("errorMessage", "비밀번호 재설정 중 오류가 발생했습니다.");
                }
            } else {
                request.setAttribute("errorMessage", "입력하신 정보와 일치하는 계정을 찾을 수 없습니다.");
            }

            request.setAttribute("findType", "password");
            request.setAttribute("pageTitle", "비밀번호 찾기");
        }

        request.getRequestDispatcher("findAccount.jsp").forward(request, response);
    }

    // 임시 비밀번호 생성
    private String generateTempPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$";
        StringBuilder tempPassword = new StringBuilder();

        for (int i = 0; i < 8; i++) {
            int index = (int) (Math.random() * chars.length());
            tempPassword.append(chars.charAt(index));
        }

        return tempPassword.toString();
    }
}