<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.kbofan.dto.User" %>
<%
    User user = (User)session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>좌석 확인 - KBO Fan</title>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
        }
        iframe {
            width: 100%;
            height: 100vh;
            border: none;
        }
    </style>
</head>
<body>
<jsp:include page="/includes/header.jsp">
    <jsp:param name="pageTitle" value="좌석 확인" />
    <jsp:param name="activeMenu" value="ticket" />
</jsp:include>

<iframe src="https://myseatcheck.com/%ED%94%84%EB%A1%9C%EC%95%BC%EA%B5%AC-%EC%9E%90%EB%A6%AC%EC%96%B4%EB%95%8C/" allowfullscreen></iframe>

<jsp:include page="/includes/footer.jsp" />
</body>
</html>
