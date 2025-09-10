<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KBO Fan - 로그인</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        .logo img {
            max-width: 150px;
        }
        .find-links {
            text-align: center;
            margin-top: 15px;
        }
        .find-links a {
            color: #6c757d;
            text-decoration: none;
            font-size: 0.9em;
        }
        .find-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="login-container">
        <div class="logo">
            <h2>KBO Fan</h2>
            <p>한국 프로야구 팬 커뮤니티</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success" role="alert">
            <%= request.getAttribute("successMessage") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="mb-3">
                <label for="loginId" class="form-label">아이디</label>
                <input type="text" class="form-control" id="loginId" name="loginId" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">로그인</button>
            </div>
        </form>

        <!-- 아이디/비밀번호 찾기 링크 추가 -->
        <div class="find-links">
            <a href="${pageContext.request.contextPath}/findAccount?type=id">아이디 찾기</a> |
            <a href="${pageContext.request.contextPath}/findAccount?type=password">비밀번호 찾기</a>
        </div>

        <div class="mt-3 text-center">
            <p>계정이 없으신가요? <a href="${pageContext.request.contextPath}/register">회원가입</a></p>
        </div>

        <div class="mt-3 small text-muted">
            <p>문제가 지속되면 관리자에게 문의하세요.</p>
            <p>서버 시간: <%= new java.util.Date() %></p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>