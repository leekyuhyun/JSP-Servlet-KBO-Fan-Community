<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.kbofan.dto.User" %>
<%
    // 세션에서 사용자 정보 가져오기
    User user = (User) session.getAttribute("user");

    if (user != null) {
        String action = request.getParameter("action");

        if ("grant".equals(action)) {
            // 관리자 권한 부여
            user.setAdmin(true);
            session.setAttribute("user", user);
            System.out.println("관리자 권한 부여: " + user.getLoginId());
        } else if ("remove".equals(action)) {
            // 관리자 권한 제거
            user.setAdmin(false);
            session.setAttribute("user", user);
            System.out.println("관리자 권한 제거: " + user.getLoginId());
        }
    }

    // 세션 디버깅 페이지로 리다이렉트
    response.sendRedirect(request.getContextPath() + "/session_debug.jsp");
%>