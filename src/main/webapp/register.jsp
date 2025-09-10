<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <!-- JSTL core 태그 사용 -->

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KBO Fan - 회원가입</title>

    <!-- Bootstrap CSS 포함 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        /* 페이지 전체 배경 및 회원가입 폼 디자인 */
        body {
            background-color: #f8f9fa;
        }
        .register-container {
            max-width: 500px;
            margin: 50px auto;
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
    </style>
</head>
<body>

<div class="container">
    <div class="register-container">
        <!-- 로고 및 소개 문구 -->
        <div class="logo">
            <h2>KBO Fan</h2>
            <p>한국 프로야구 팬 커뮤니티</p>
        </div>

        <!-- 에러 메시지 출력 (서블릿에서 전달된 경우) -->
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <!-- 회원가입 폼 시작 -->
        <form action="register" method="post" id="registerForm">

            <!-- 이름 입력 -->
            <div class="mb-3">
                <label for="username" class="form-label">이름</label>
                <input type="text" class="form-control" id="username" name="username" maxlength="10" required>
            </div>

            <!-- 로그인 ID 입력 -->
            <div class="mb-3">
                <label for="loginId" class="form-label">아이디</label>
                <input type="text" class="form-control" id="loginId" name="loginId" maxlength="20" required>
                <div class="form-text">영문, 숫자 조합 (4~20자)</div>
            </div>

            <!-- 닉네임 입력 -->
            <div class="mb-3">
                <label for="nickname" class="form-label">닉네임</label>
                <input type="text" class="form-control" id="nickname" name="nickname" maxlength="20" required>
            </div>

            <!-- 비밀번호 입력 -->
            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" class="form-control" id="password" name="password" required>
                <div class="form-text">영문, 숫자, 특수문자 조합 (8자 이상)</div>
            </div>

            <!-- 비밀번호 확인 -->
            <div class="mb-3">
                <label for="confirmPassword" class="form-label">비밀번호 확인</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
            </div>

            <!-- 이메일 입력 -->
            <div class="mb-3">
                <label for="email" class="form-label">이메일</label>
                <input type="email" class="form-control" id="email" name="email" maxlength="50" required>
            </div>

            <!-- 응원팀 선택 -->
            <div class="mb-3">
                <label for="teamId" class="form-label">응원팀</label>
                <select class="form-select" id="teamId" name="teamId" required>
                    <option value="" selected disabled>응원팀을 선택하세요</option>
                    <!-- 서버에서 전달된 teams 리스트를 JSTL로 반복 출력 -->
                    <c:forEach var="team" items="${teams}">
                        <option value="${team.teamId}">${team.name}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- 회원가입 버튼 -->
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">회원가입</button>
            </div>
        </form>

        <!-- 로그인 링크 -->
        <div class="mt-3 text-center">
            <p>이미 계정이 있으신가요? <a href="login">로그인</a></p>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- 유효성 검사 스크립트 -->
<script>
    document.getElementById('registerForm').addEventListener('submit', function(event) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        // 비밀번호 확인 일치 여부 검사
        if (password !== confirmPassword) {
            event.preventDefault();
            alert('비밀번호가 일치하지 않습니다.');
        }

        // 아이디 유효성 검사 (영문/숫자 4~20자)
        const loginId = document.getElementById('loginId').value;
        if (!/^[a-zA-Z0-9]{4,20}$/.test(loginId)) {
            event.preventDefault();
            alert('아이디는 영문, 숫자 조합 4~20자로 입력해주세요.');
        }

        // 비밀번호 유효성 검사 (영문 + 숫자 + 특수문자 포함 8자 이상)
        if (!/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/.test(password)) {
            event.preventDefault();
            alert('비밀번호는 영문, 숫자, 특수문자 조합 8자 이상으로 입력해주세요.');
        }
    });
</script>
</body>
</html>
