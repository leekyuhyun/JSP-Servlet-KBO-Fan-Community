<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="header.jsp">
  <jsp:param name="title" value="관리자 대시보드" />
</jsp:include>

<!-- 사이드바 포함 -->
<jsp:include page="sidebar.jsp">
  <jsp:param name="active" value="dashboard" />
</jsp:include>

<!-- 메인 컨텐츠 -->
<main class="col-md-10 ml-sm-auto main-content">
  <!-- 페이지 헤더 -->
  <div class="page-header fade-in-up">
    <div class="d-flex justify-content-between align-items-center">
      <div>
        <h1 class="h2 mb-2">관리자 대시보드</h1>
        <p class="mb-0">KBO Fan 커뮤니티 관리 시스템에 오신 것을 환영합니다</p>
      </div>
      <div class="text-end">
        <div class="small text-muted mb-1">
          <i class="fas fa-clock me-1"></i>현재 시간
        </div>
        <div class="h5 mb-0 fw-bold text-primary">
          <span id="currentTime"></span>
        </div>
      </div>
    </div>
  </div>

  <!-- 통계 카드 -->
  <div class="row mb-5">
    <div class="col-md-3 mb-4">
      <div class="card stat-card h-100 fade-in-up" style="animation-delay: 0.1s">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h6 class="card-title text-muted mb-2 fw-semibold">전체 사용자</h6>
              <h2 class="text-primary mb-1 fw-bold">${totalUsers}</h2>
              <small class="text-success">
                <i class="fas fa-arrow-up me-1"></i>활성 사용자
              </small>
            </div>
            <div class="stat-icon text-primary">
              <i class="fas fa-users"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-4">
      <div class="card stat-card h-100 fade-in-up" style="animation-delay: 0.2s">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h6 class="card-title text-muted mb-2 fw-semibold">전체 게시글</h6>
              <h2 class="text-success mb-1 fw-bold">${totalPosts}</h2>
              <small class="text-info">
                <i class="fas fa-comments me-1"></i>커뮤니티 활동
              </small>
            </div>
            <div class="stat-icon text-success">
              <i class="fas fa-file-text"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-4">
      <div class="card stat-card h-100 fade-in-up" style="animation-delay: 0.3s">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h6 class="card-title text-muted mb-2 fw-semibold">전체 경기</h6>
              <h2 class="text-warning mb-1 fw-bold">${totalGames}</h2>
              <small class="text-primary">
                <i class="fas fa-calendar me-1"></i>시즌 경기
              </small>
            </div>
            <div class="stat-icon text-warning">
              <i class="fas fa-baseball-ball"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-4">
      <div class="card stat-card h-100 fade-in-up" style="animation-delay: 0.4s">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h6 class="card-title text-muted mb-2 fw-semibold">신규 가입자</h6>
              <h2 class="text-info mb-1 fw-bold">${newUsers}</h2>
              <small class="text-muted">
                <i class="fas fa-calendar-week me-1"></i>최근 7일
              </small>
            </div>
            <div class="stat-icon text-info">
              <i class="fas fa-user-plus"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 최근 활동 -->
  <div class="row">
    <div class="col-md-6 mb-4">
      <div class="card h-100 fade-in-up" style="animation-delay: 0.5s">
        <div class="card-header">
          <div class="d-flex align-items-center">
            <div class="rounded-circle bg-primary bg-opacity-10 p-2 me-3">
              <i class="fas fa-newspaper text-primary"></i>
            </div>
            <h5 class="mb-0 fw-semibold">최근 게시글</h5>
          </div>
        </div>
        <div class="card-body p-0">
          <c:choose>
            <c:when test="${not empty recentPosts}">
              <div class="list-group list-group-flush">
                <c:forEach var="post" items="${recentPosts}" varStatus="status">
                  <div class="list-group-item" style="animation-delay: ${0.6 + status.index * 0.1}s">
                    <div class="d-flex w-100 justify-content-between align-items-start">
                      <div class="flex-grow-1">
                        <h6 class="mb-2 text-truncate fw-semibold" style="max-width: 280px;" title="${post.title}">
                            ${post.title}
                        </h6>
                        <p class="mb-2 text-muted small d-flex align-items-center">
                          <i class="fas fa-user me-2"></i>${post.authorNickname}
                        </p>
                        <div class="d-flex gap-3">
                          <small class="text-muted d-flex align-items-center">
                            <i class="fas fa-eye me-1"></i>${post.viewCount}
                          </small>
                          <small class="text-muted d-flex align-items-center">
                            <i class="fas fa-heart me-1"></i>${post.likeCount}
                          </small>
                          <small class="text-muted d-flex align-items-center">
                            <i class="fas fa-comment me-1"></i>${post.commentCount}
                          </small>
                        </div>
                      </div>
                      <div class="text-end">
                        <small class="text-muted">${post.formattedCreatedAt}</small>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </c:when>
            <c:otherwise>
              <div class="text-center py-5 text-muted">
                <div class="rounded-circle bg-light p-4 d-inline-flex mb-3">
                  <i class="fas fa-inbox fa-2x"></i>
                </div>
                <p class="mb-0">최근 게시글이 없습니다.</p>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <!-- 최근 경기 -->
    <div class="col-md-6 mb-4">
      <div class="card h-100 fade-in-up" style="animation-delay: 0.6s">
        <div class="card-header">
          <div class="d-flex align-items-center">
            <div class="rounded-circle bg-warning bg-opacity-10 p-2 me-3">
              <i class="fas fa-baseball-ball text-warning"></i>
            </div>
            <h5 class="mb-0 fw-semibold">최근 경기</h5>
          </div>
        </div>
        <div class="card-body p-0">
          <c:choose>
            <c:when test="${not empty recentGames}">
              <div class="list-group list-group-flush">
                <c:forEach var="game" items="${recentGames}" varStatus="status">
                  <div class="list-group-item" style="animation-delay: ${0.7 + status.index * 0.1}s">
                    <div class="d-flex w-100 justify-content-between align-items-center">
                      <div>
                        <h6 class="mb-2 fw-semibold">
                          <span class="text-primary">${game.awayTeamName}</span>
                          <span class="text-muted mx-2">vs</span>
                          <span class="text-primary">${game.homeTeamName}</span>
                        </h6>
                        <p class="mb-2 fw-bold text-dark">${game.scoreDisplay}</p>
                        <small class="text-muted d-flex align-items-center">
                          <i class="fas fa-map-marker-alt me-1"></i>${game.stadium}
                        </small>
                      </div>
                      <div class="text-end">
                        <div class="badge
                                                    <c:choose>
                                                        <c:when test="${game.status == 'COMPLETED'}">bg-success</c:when>
                                                        <c:when test="${game.status == 'SCHEDULED'}">bg-primary</c:when>
                                                        <c:otherwise>bg-danger</c:otherwise>
                                                    </c:choose>
                                                    mb-2">
                          <c:choose>
                            <c:when test="${game.status == 'COMPLETED'}">완료</c:when>
                            <c:when test="${game.status == 'SCHEDULED'}">예정</c:when>
                            <c:otherwise>취소</c:otherwise>
                          </c:choose>
                        </div>
                        <div class="small text-muted">
                          <fmt:formatDate value="${game.gameDate}" pattern="MM-dd"/>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </c:when>
            <c:otherwise>
              <div class="text-center py-5 text-muted">
                <div class="rounded-circle bg-light p-4 d-inline-flex mb-3">
                  <i class="fas fa-calendar-times fa-2x"></i>
                </div>
                <p class="mb-0">최근 경기가 없습니다.</p>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>
</main>

<jsp:include page="footer.jsp" />
