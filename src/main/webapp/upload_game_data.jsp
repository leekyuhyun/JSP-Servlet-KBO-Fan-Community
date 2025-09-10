<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // 로그인 확인
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KBO Fan - 경기 데이터 업로드</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .upload-container {
            max-width: 700px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .team-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-left: 10px;
        }
    </style>
</head>
<body>
<!-- 네비게이션 바 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="main.jsp">
            <i class="bi bi-baseball"></i> KBO Fan
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="main.jsp">홈</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="team_list.jsp">팀 정보</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="game/schedule.jsp">경기 일정</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">커뮤니티</a>
                </li>
            </ul>
            <div class="d-flex align-items-center">
                    <span class="text-light me-3">
                        <i class="bi bi-person-circle"></i>
                        ${user.nickname}
                        <span class="team-badge bg-light text-dark">
                            ${user.teamName}
                        </span>
                    </span>
                <a href="logout.jsp" class="btn btn-outline-light btn-sm">로그아웃</a>
            </div>
        </div>
    </div>
</nav>

<!-- 메인 컨텐츠 -->
<div class="container">
    <div class="upload-container">
        <h2 class="mb-4"><i class="bi bi-upload"></i> 경기 데이터 업로드</h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                    ${errorMessage}
            </div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">
                    ${successMessage}
            </div>
        </c:if>

        <c:if test="${not empty errorMessages}">
            <div class="alert alert-warning" role="alert">
                <h5>다음 오류가 발생했습니다:</h5>
                <ul>
                    <c:forEach var="error" items="${errorMessages}">
                        <li>${error}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">CSV 파일 형식</h5>
                <p class="card-text">CSV 파일은 다음 형식을 따라야 합니다:</p>
                <pre class="bg-light p-3">
game_date,game_time,stadium,away_team,home_team,away_score,home_score,away_pitcher,away_pitcher_result,home_pitcher,home_pitcher_result,winner,etc
2025.03.22,14:00,수원 KT위즈파크,한화 이글스,KT 위즈,4,3,박상원,승,김민수,패,한화 이글스,종료
2025.03.29,14:00,잠실 야구장,한화 이글스,LG 트윈스,,,,,,,,취소
2025.03.30,14:00,창원 NC파크,두산 베어스,NC 다이노스,,,,,,,,
                    </pre>
                <p class="card-text text-muted">
                    - 첫 번째 줄은 헤더로 처리되며 무시됩니다.<br>
                    - 경기가 취소된 경우 etc 필드에 "취소"를 입력하고 점수와 투수 정보는 비워두거나 입력해도 됩니다.<br>
                    - 경기가 완료된 경우 etc 필드에 "종료"를 입력하고 점수와 투수 정보를 모두 입력하세요.<br>
                    - 예정된 경기는 점수와 투수 정보를 비워두고 etc 필드도 비워두세요.
                </p>
            </div>
        </div>

        <form action="upload-game-data" method="post" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="csvFile" class="form-label">CSV 파일 선택</label>
                <input type="file" class="form-control" id="csvFile" name="csvFile" accept=".csv" required>
            </div>
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-upload"></i> 업로드
                </button>
            </div>
        </form>

        <div class="mt-3 text-center">
            <a href="main.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> 메인으로 돌아가기
            </a>
        </div>
    </div>
</div>

<!-- 푸터 -->
<footer class="bg-dark text-light py-4 mt-5">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5>KBO Fan</h5>
                <p>한국 프로야구 팬 커뮤니티</p>
            </div>
            <div class="col-md-6 text-md-end">
                <p>&copy; 2023 KBO Fan. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
