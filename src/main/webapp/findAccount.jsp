<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KBO Fan - ${pageTitle}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .find-container {
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
        .tab-buttons {
            display: flex;
            margin-bottom: 20px;
        }
        .tab-button {
            flex: 1;
            padding: 10px;
            text-align: center;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            text-decoration: none;
            color: #6c757d;
        }
        .tab-button.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .tab-button:hover {
            text-decoration: none;
            color: #495057;
        }
        .tab-button.active:hover {
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="find-container">
        <div class="logo">
            <h2>KBO Fan</h2>
            <p>${pageTitle}</p>
        </div>

        <!-- 탭 버튼 -->
        <div class="tab-buttons">
            <a href="${pageContext.request.contextPath}/findAccount?type=id"
               class="tab-button ${findType == 'id' ? 'active' : ''}">아이디 찾기</a>
            <a href="${pageContext.request.contextPath}/findAccount?type=password"
               class="tab-button ${findType == 'password' ? 'active' : ''}">비밀번호 찾기</a>
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

        <% if ("id".equals(request.getAttribute("findType"))) { %>
        <!-- 아이디 찾기 폼 -->
        <form action="${pageContext.request.contextPath}/findAccount" method="post">
            <input type="hidden" name="type" value="id">
            <div class="mb-3">
                <label for="username" class="form-label">이름</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">이메일</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">아이디 찾기</button>
            </div>
        </form>
        <% } else { %>
        <!-- 비밀번호 찾기 폼 -->
        <form action="${pageContext.request.contextPath}/findAccount" method="post">
            <input type="hidden" name="type" value="password">
            <div class="mb-3">
                <label for="loginId" class="form-label">아이디</label>
                <input type="text" class="form-control" id="loginId" name="loginId" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">이메일</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">임시 비밀번호 발급</button>
            </div>
        </form>
        <% } %>

        <div class="mt-3 text-center">
            <p><a href="${pageContext.request.contextPath}/login">로그인으로 돌아가기</a></p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>