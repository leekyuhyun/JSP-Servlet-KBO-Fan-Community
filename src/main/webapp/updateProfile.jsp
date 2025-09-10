<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KBO Fan - 회원정보 수정</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .update-container {
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
        .password-section {
            border-top: 1px solid #dee2e6;
            margin-top: 20px;
            padding-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="update-container">
        <div class="logo">
            <h2>KBO Fan</h2>
            <p>회원정보 수정</p>
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

        <%
            com.kbofan.dto.User currentUser = (com.kbofan.dto.User) request.getAttribute("currentUser");
            if (currentUser == null) {
                currentUser = (com.kbofan.dto.User) session.getAttribute("user");
            }
        %>

        <% if (currentUser != null) { %>
        <form action="${pageContext.request.contextPath}/updateProfile" method="post" id="updateForm">
            <div class="mb-3">
                <label for="username" class="form-label">이름</label>
                <input type="text" class="form-control" id="username" name="username"
                       value="<%= currentUser.getUsername() != null ? currentUser.getUsername() : "" %>"
                       maxlength="10" required>
            </div>

            <div class="mb-3">
                <label for="loginId" class="form-label">아이디</label>
                <input type="text" class="form-control" id="loginId" name="loginId"
                       value="<%= currentUser.getLoginId() != null ? currentUser.getLoginId() : "" %>"
                       readonly style="background-color: #e9ecef;">
                <div class="form-text">아이디는 변경할 수 없습니다.</div>
            </div>

            <div class="mb-3">
                <label for="nickname" class="form-label">닉네임</label>
                <input type="text" class="form-control" id="nickname" name="nickname"
                       value="<%= currentUser.getNickname() != null ? currentUser.getNickname() : "" %>"
                       maxlength="20" required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">이메일</label>
                <input type="email" class="form-control" id="email" name="email"
                       value="<%= currentUser.getEmail() != null ? currentUser.getEmail() : "" %>"
                       maxlength="50" required>
            </div>

            <div class="mb-3">
                <label for="teamId" class="form-label">응원팀</label>
                <select class="form-select" id="teamId" name="teamId" required>
                    <option value="" disabled>응원팀을 선택하세요</option>
                    <c:forEach var="team" items="${teams}">
                        <option value="${team.teamId}"
                                <c:if test="${team.teamId == currentUser.teamId}">selected</c:if>>
                                ${team.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- 비밀번호 변경 섹션 -->
            <div class="password-section">
                <h5>비밀번호 변경 (선택사항)</h5>
                <div class="form-text mb-3">비밀번호를 변경하지 않으려면 아래 필드들을 비워두세요.</div>

                <div class="mb-3">
                    <label for="currentPassword" class="form-label">현재 비밀번호</label>
                    <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                </div>

                <div class="mb-3">
                    <label for="newPassword" class="form-label">새 비밀번호</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword">
                    <div class="form-text">영문, 숫자, 특수문자 조합 (8자 이상)</div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                </div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">정보 수정</button>
                <a href="${pageContext.request.contextPath}/main.jsp" class="btn btn-secondary">취소</a>
            </div>
        </form>
        <% } else { %>
        <div class="alert alert-warning" role="alert">
            사용자 정보를 불러올 수 없습니다. 다시 로그인해주세요.
            <br><a href="${pageContext.request.contextPath}/login">로그인 페이지로 이동</a>
        </div>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('updateForm').addEventListener('submit', function(event) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const currentPassword = document.getElementById('currentPassword').value;

        // 새 비밀번호가 입력된 경우에만 검증
        if (newPassword.trim() !== '') {
            // 현재 비밀번호 확인
            if (currentPassword.trim() === '') {
                event.preventDefault();
                alert('비밀번호를 변경하려면 현재 비밀번호를 입력해주세요.');
                return;
            }

            // 새 비밀번호 확인
            if (newPassword !== confirmPassword) {
                event.preventDefault();
                alert('새 비밀번호가 일치하지 않습니다.');
                return;
            }

            // 비밀번호 강도 검증
            if (!/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/.test(newPassword)) {
                event.preventDefault();
                alert('새 비밀번호는 영문, 숫자, 특수문자 조합 8자 이상으로 입력해주세요.');
                return;
            }
        }
    });
</script>
</body>
</html>