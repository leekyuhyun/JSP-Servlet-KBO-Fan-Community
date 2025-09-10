<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.kbofan.dto.User" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>
    <c:choose>
      <c:when test="${not empty param.pageTitle}">
        ${param.pageTitle} - KBO Fan 커뮤니티
      </c:when>
      <c:otherwise>
        KBO Fan 커뮤니티
      </c:otherwise>
    </c:choose>
  </title>

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">

  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #f5f7fa;
      color: #333333;
      line-height: 1.6;
    }

    /* 네비게이션 바 */
    .navbar {
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      padding: 0.8rem 1rem;
    }

    .navbar-brand {
      font-weight: 700;
      font-size: 1.5rem;
      display: flex;
      align-items: center;
    }

    .navbar-brand img {
      width: 40px;
      height: 40px;
      margin-right: 10px;
      filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
    }

    .navbar-nav .nav-link {
      font-weight: 500;
      padding: 0.5rem 1rem;
      margin: 0 0.2rem;
      border-radius: 5px;
      transition: all 0.3s ease;
    }

    .navbar-nav .nav-link:hover {
      background-color: rgba(255, 255, 255, 0.2);
    }

    .navbar-nav .nav-link.active {
      background-color: rgba(255, 255, 255, 0.3);
      font-weight: 700;
    }

    .team-badge {
      display: inline-block;
      padding: 5px 12px;
      border-radius: 20px;
      font-size: 0.85rem;
      font-weight: 600;
      margin-left: 10px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      transition: all 0.3s ease;
    }

    .team-badge:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }

    /* 팀 로고 */
    .team-logo {
      width: 36px;
      height: 36px;
      object-fit: contain;
      filter: drop-shadow(0 2px 3px rgba(0, 0, 0, 0.1));
      transition: all 0.3s ease;
    }

    .team-logo:hover {
      transform: scale(1.1);
    }

    /* 기본 팀 색상 (로그인하지 않은 경우) */
    .default-navbar {
      background-color: #dc3545 !important;
    }

    /* 알림 메시지 */
    .alert {
      margin-bottom: 0;
      border-radius: 0;
    }
  </style>

  <!-- Custom CSS -->
  <c:if test="${not empty param.customCSS}">
    ${param.customCSS}
  </c:if>
</head>
<body>

<!-- 네비게이션 바 -->
<nav class="navbar navbar-expand-lg navbar-dark ${empty sessionScope.user ? 'default-navbar' : ''}"
     <c:if test="${not empty sessionScope.user}">style="background-color: ${sessionScope.user.teamPrimaryColor}"</c:if>>
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/main.jsp">
      <c:choose>
        <c:when test="${not empty sessionScope.user and not empty sessionScope.user.teamLogo}">
          <img src="${sessionScope.user.teamLogo}" alt="${sessionScope.user.teamName}" class="team-logo">
        </c:when>
        <c:otherwise>
          <i class="bi bi-baseball fs-3 me-2"></i>
        </c:otherwise>
      </c:choose>
      KBO Fan
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/" class="nav-link ${param.activeMenu == 'home' ? 'active' : ''}">
            <i class="bi bi-house me-1"></i>홈
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/team/team_list.jsp" class="nav-link ${param.activeMenu == 'team' ? 'active' : ''}">
            <i class="bi bi-shield me-1"></i>팀 정보
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/game/schedule.jsp" class="nav-link ${param.activeMenu == 'game' ? 'active' : ''}">
            <i class="bi bi-calendar-event me-1"></i>경기 일정
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/community" class="nav-link ${param.activeMenu == 'community' ? 'active' : ''}">
            <i class="bi bi-chat-dots me-1"></i>커뮤니티
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/ticket.jsp" class="nav-link ${param.activeMenu == 'ticket' ? 'active' : ''}">
            <i class="bi bi-ticket-perforated me-1"></i>좌석 확인
          </a>
        </li>

        <c:if test="${not empty sessionScope.user}">
          <li class="nav-item">
            <a class="nav-link ${param.activeMenu == 'mypage' ? 'active' : ''}" href="${pageContext.request.contextPath}/mypage.jsp">
              <i class="bi bi-person me-1"></i>마이 페이지
            </a>
          </li>

          <c:if test="${sessionScope.user.admin}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle ${param.activeMenu == 'admin' ? 'active' : ''}" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-gear me-1"></i>관리자
              </a>
              <ul class="dropdown-menu" aria-labelledby="adminDropdown">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/game_management.jsp">
                  <i class="bi bi-calendar-check me-2"></i>경기 관리
                </a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/team_management.jsp">
                  <i class="bi bi-people-fill me-2"></i>팀 관리
                </a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/user_management.jsp">
                  <i class="bi bi-person-gear me-2"></i>사용자 관리
                </a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/data_upload.jsp">
                  <i class="bi bi-upload me-2"></i>데이터 업로드
                </a></li>
              </ul>
            </li>
          </c:if>
        </c:if>
      </ul>

      <div class="d-flex align-items-center">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <span class="text-light me-3">
              <i class="bi bi-person-circle me-1"></i>
              ${sessionScope.user.nickname}
              <c:if test="${not empty sessionScope.user.teamName}">
                <span class="team-badge" style="background-color: ${sessionScope.user.teamSecondaryColor}; color: ${sessionScope.user.teamPrimaryColor};">
                    ${sessionScope.user.teamName}
                </span>
              </c:if>
            </span>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-outline-light btn-sm">
              <i class="bi bi-box-arrow-right me-1"></i>로그아웃
            </a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-light btn-sm me-2">
              <i class="bi bi-box-arrow-in-right me-1"></i>로그인
            </a>
            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-light btn-sm">
              <i class="bi bi-person-plus me-1"></i>회원가입
            </a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</nav>

<!-- 성공/오류 메시지 표시 -->
<c:if test="${not empty param.success}">
  <div class="alert alert-success alert-dismissible fade show" role="alert">
    <i class="bi bi-check-circle me-2"></i>
    <c:choose>
      <c:when test="${param.success == 'post_created'}">게시글이 성공적으로 작성되었습니다.</c:when>
      <c:when test="${param.success == 'post_updated'}">게시글이 성공적으로 수정되었습니다.</c:when>
      <c:when test="${param.success == 'post_deleted'}">게시글이 성공적으로 삭제되었습니다.</c:when>
      <c:when test="${param.success == 'comment_deleted'}">댓글이 성공적으로 삭제되었습니다.</c:when>
      <c:otherwise>작업이 성공적으로 완료되었습니다.</c:otherwise>
    </c:choose>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
</c:if>

<c:if test="${not empty param.error}">
  <div class="alert alert-danger alert-dismissible fade show" role="alert">
    <i class="bi bi-exclamation-triangle me-2"></i>
    <c:choose>
      <c:when test="${param.error == 'not_found'}">요청하신 게시글을 찾을 수 없습니다.</c:when>
      <c:when test="${param.error == 'access_denied'}">접근 권한이 없습니다.</c:when>
      <c:when test="${param.error == 'invalid_id'}">잘못된 요청입니다.</c:when>
      <c:when test="${param.error == 'system_error'}">시스템 오류가 발생했습니다.</c:when>
      <c:when test="${param.error == 'not_logged_in'}">로그인이 필요합니다.</c:when>
      <c:otherwise>오류가 발생했습니다.</c:otherwise>
    </c:choose>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
</c:if>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
  // 알림 메시지 자동 숨김
  document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
      setTimeout(function() {
        const bsAlert = new bootstrap.Alert(alert);
        bsAlert.close();
      }, 5000); // 5초 후 자동 숨김
    });
  });
</script>

</body>
</html>