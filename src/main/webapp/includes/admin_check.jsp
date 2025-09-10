<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.kbofan.dto.User" %>
<%
  // 디버깅 로그 추가
  System.out.println("admin_check.jsp 실행");

  // 세션에서 사용자 정보 가져오기
  User user = (User) session.getAttribute("user");

  // 디버깅 로그 추가
  if (user != null) {
    System.out.println("세션 사용자: " + user.getLoginId() + ", isAdmin=" + user.isAdmin());
  } else {
    System.out.println("세션에 사용자 정보 없음");
  }

  // 로그인하지 않았거나 관리자가 아닌 경우 로그인 페이지로 리다이렉트
  if (user == null) {
    System.out.println("사용자 정보 없음 - 로그인 페이지로 리다이렉트");
    response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_logged_in");
    return;
  }

  // admin 로그인 ID를 가진 사용자는 항상 관리자로 처리
  if ("admin".equals(user.getLoginId())) {
    System.out.println("admin 로그인 ID 확인 - 관리자 권한 부여");
    // 세션에 저장된 User 객체의 admin 속성을 true로 설정
    user.setAdmin(true);
    session.setAttribute("user", user);
  } else if (!user.isAdmin()) {
    System.out.println("관리자 권한 없음 - 로그인 페이지로 리다이렉트");
    response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_admin");
    return;
  }

  System.out.println("관리자 권한 확인 완료");
%>