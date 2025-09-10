<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="사용자 관리" />
</jsp:include>

<!-- 사이드바 포함 -->
<jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="users" />
</jsp:include>

<!-- 메인 컨텐츠 -->
<main class="col-md-10 ml-sm-auto main-content">
    <!-- 페이지 헤더 -->
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h2 mb-1">사용자 관리</h1>
                <p class="mb-0 opacity-75">사용자 계정 관리 및 조회</p>
            </div>
        </div>
    </div>

    <!-- 검색 폼 -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin">
                <input type="hidden" name="action" value="users">
                <div class="row">
                    <div class="col-md-3">
                        <select name="searchType" class="form-select">
                            <option value="all" ${searchType == 'all' ? 'selected' : ''}>전체</option>
                            <option value="username" ${searchType == 'username' ? 'selected' : ''}>이름</option>
                            <option value="nickname" ${searchType == 'nickname' ? 'selected' : ''}>닉네임</option>
                            <option value="loginId" ${searchType == 'loginId' ? 'selected' : ''}>아이디</option>
                            <option value="email" ${searchType == 'email' ? 'selected' : ''}>이메일</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <input type="text" name="searchKeyword" class="form-control"
                               placeholder="검색어를 입력하세요" value="${searchKeyword}">
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary btn-custom w-100">
                            <i class="fas fa-search"></i> 검색
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 사용자 목록 -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-users text-primary"></i> 사용자 목록 (총 ${totalCount}명)
            </h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty users}">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>이름</th>
                                <th>닉네임</th>
                                <th>아이디</th>
                                <th>이메일</th>
                                <th>응원팀</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.userId}</td>
                                    <td>${user.username}</td>
                                    <td>${user.nickname}</td>
                                    <td>${user.loginId}</td>
                                    <td>${user.email}</td>
                                    <td>${user.teamName != null ? user.teamName : '없음'}</td>
                                    <td>
                                        <c:if test="${user.loginId != 'admin'}">
                                            <button type="button" class="btn btn-danger btn-sm btn-custom"
                                                    onclick="deleteUser(${user.userId}, '${user.username}')">
                                                <i class="fas fa-trash"></i> 삭제
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- 페이지네이션 -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?action=users&page=${currentPage-1}&searchType=${searchType}&searchKeyword=${searchKeyword}">이전</a>
                                    </li>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?action=users&page=${i}&searchType=${searchType}&searchKeyword=${searchKeyword}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?action=users&page=${currentPage+1}&searchType=${searchType}&searchKeyword=${searchKeyword}">다음</a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-users fa-3x mb-3"></i>
                        <p>사용자가 없습니다.</p>
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
                <h5 class="modal-title">사용자 삭제 확인</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p id="deleteMessage"></p>
                <div class="alert alert-warning">
                    <strong>주의:</strong> 사용자를 삭제하면 해당 사용자의 모든 게시글과 댓글도 함께 삭제됩니다.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                    <input type="hidden" name="action" value="deleteUser">
                    <input type="hidden" name="userId" id="deleteUserId">
                    <button type="submit" class="btn btn-danger">삭제</button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script>
    function deleteUser(userId, username) {
        document.getElementById('deleteUserId').value = userId;
        document.getElementById('deleteMessage').textContent =
            `정말로 "${username}" 사용자를 삭제하시겠습니까?`;

        const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
        modal.show();
    }

    // 성공/오류 메시지 표시
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('success') === 'user_deleted') {
        alert('사용자가 성공적으로 삭제되었습니다.');
    } else if (urlParams.get('error') === 'delete_failed') {
        alert('사용자 삭제에 실패했습니다.');
    } else if (urlParams.get('error') === 'invalid_id') {
        alert('잘못된 사용자 ID입니다.');
    }
</script>
