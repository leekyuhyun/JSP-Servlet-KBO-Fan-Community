<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="경기 관리" />
</jsp:include>

<!-- 사이드바 포함 -->
<jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="games" />
</jsp:include>

<!-- 메인 컨텐츠 -->
<main class="col-md-10 ml-sm-auto main-content">
    <!-- 페이지 헤더 -->
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h2 mb-1">경기 관리</h1>
                <p class="mb-0 opacity-75">경기 일정 및 결과 관리</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin?action=game-form" class="btn btn-primary btn-custom">
                    <i class="fas fa-plus"></i> 새 경기 추가
                </a>
            </div>
        </div>
    </div>

    <!-- 날짜 선택 -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin">
                <input type="hidden" name="action" value="games">
                <div class="row align-items-end">
                    <div class="col-md-4">
                        <label for="date" class="form-label">경기 날짜</label>
                        <input type="date" name="date" id="date" class="form-control"
                               value="<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd'/>">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary btn-custom">
                            <i class="fas fa-search"></i> 조회
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 경기 목록 -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-baseball-ball text-warning"></i>
                <fmt:formatDate value="${selectedDate}" pattern="yyyy년 MM월 dd일"/> 경기 목록
                (${not empty games ? games.size() : 0}경기)
            </h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty games}">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>시간</th>
                                <th>경기</th>
                                <th>구장</th>
                                <th>상태</th>
                                <th>점수</th>
                                <th>투수</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="game" items="${games}">
                                <tr>
                                    <td>${game.gameTime}</td>
                                    <td>
                                        <strong>${game.awayTeamName}</strong> vs <strong>${game.homeTeamName}</strong>
                                    </td>
                                    <td>${game.stadium}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${game.status == 'COMPLETED'}">
                                                <span class="badge bg-success">완료</span>
                                            </c:when>
                                            <c:when test="${game.status == 'SCHEDULED'}">
                                                <span class="badge bg-primary">예정</span>
                                            </c:when>
                                            <c:when test="${game.status == 'CANCELED'}">
                                                <span class="badge bg-danger">취소</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${game.status == 'COMPLETED'}">
                                                ${game.awayScore} - ${game.homeScore}
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <small>
                                            <c:if test="${not empty game.awayPitcher}">
                                                원정: ${game.awayPitcher}<br>
                                            </c:if>
                                            <c:if test="${not empty game.homePitcher}">
                                                홈: ${game.homePitcher}
                                            </c:if>
                                        </small>
                                    </td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin?action=game-form&gameId=${game.gameId}"
                                               class="btn btn-warning btn-sm btn-custom">
                                                <i class="fas fa-edit"></i> 수정
                                            </a>
                                            <button type="button" class="btn btn-danger btn-sm btn-custom"
                                                    onclick="deleteGame(${game.gameId}, '${game.awayTeamName} vs ${game.homeTeamName}')">
                                                <i class="fas fa-trash"></i> 삭제
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-calendar-times fa-3x mb-3"></i>
                        <p>해당 날짜에 경기가 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- 삭제 확인 모달 -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">경기 삭제 확인</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p id="deleteMessage"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <form id="deleteForm" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="deleteGame">
                    <input type="hidden" name="gameId" id="deleteGameId">
                    <button type="submit" class="btn btn-danger">삭제</button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script>
    function deleteGame(gameId, gameName) {
        document.getElementById('deleteGameId').value = gameId;
        document.getElementById('deleteMessage').textContent =
            `정말로 "${gameName}" 경기를 삭제하시겠습니까?`;
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    }

    // 성공/오류 메시지 표시
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('success') === 'game_deleted') {
        alert('경기가 성공적으로 삭제되었습니다.');
    } else if (urlParams.get('error') === 'delete_failed') {
        alert('경기 삭제에 실패했습니다.');
    } else if (urlParams.get('success') === 'game_saved') {
        alert('경기가 성공적으로 저장되었습니다.');
    } else if (urlParams.get('error') === 'save_failed') {
        alert('경기 저장에 실패했습니다.');
    }
</script>
