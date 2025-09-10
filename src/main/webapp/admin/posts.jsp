<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="header.jsp">
  <jsp:param name="title" value="게시글 관리" />
</jsp:include>

<!-- 사이드바 포함 -->
<jsp:include page="sidebar.jsp">
  <jsp:param name="active" value="posts" />
</jsp:include>

<!-- 메인 컨텐츠 -->
<main class="col-md-10 ml-sm-auto main-content">
  <!-- 페이지 헤더 -->
  <div class="page-header">
    <div class="d-flex justify-content-between align-items-center">
      <div>
        <h1 class="h2 mb-1">게시글 관리</h1>
        <p class="mb-0 opacity-75">커뮤니티 게시글 관리 및 조회</p>
      </div>
    </div>
  </div>

  <!-- 검색 폼 -->
  <div class="card mb-4">
    <div class="card-body">
      <form method="get" action="${pageContext.request.contextPath}/admin">
        <input type="hidden" name="action" value="posts">
        <div class="row">
          <div class="col-md-2">
            <select name="category" class="form-select">
              <option value="all" ${category == 'all' ? 'selected' : ''}>전체 카테고리</option>
              <option value="free" ${category == 'free' ? 'selected' : ''}>자유게시판</option>
              <option value="analysis" ${category == 'analysis' ? 'selected' : ''}>경기분석</option>
              <option value="news" ${category == 'news' ? 'selected' : ''}>뉴스/소식</option>
              <option value="humor" ${category == 'humor' ? 'selected' : ''}>유머</option>
              <option value="question" ${category == 'question' ? 'selected' : ''}>질문</option>
              <option value="trade" ${category == 'trade' ? 'selected' : ''}>트레이드</option>
            </select>
          </div>
          <div class="col-md-2">
            <select name="searchType" class="form-select">
              <option value="all" ${searchType == 'all' ? 'selected' : ''}>전체</option>
              <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
              <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
              <option value="author" ${searchType == 'author' ? 'selected' : ''}>작성자</option>
            </select>
          </div>
          <div class="col-md-5">
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

  <!-- 게시글 목록 -->
  <div class="card">
    <div class="card-header">
      <h5 class="mb-0">
        <i class="fas fa-file-alt text-success"></i> 게시글 목록 (총 ${totalCount}개)
      </h5>
    </div>
    <div class="card-body">
      <c:choose>
        <c:when test="${not empty posts}">
          <div class="table-responsive">
            <table class="table table-hover">
              <thead>
              <tr>
                <th>ID</th>
                <th>카테고리</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>조회</th>
                <th>좋아요</th>
                <th>댓글</th>
                <th>관리</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="post" items="${posts}">
                <tr>
                  <td>${post.communityId}</td>
                  <td>
                    <span class="badge bg-secondary">${post.categoryDisplayName}</span>
                  </td>
                  <td>
                    <div class="post-title" title="${post.title}">
                      <a href="${pageContext.request.contextPath}/community?action=view&id=${post.communityId}"
                         target="_blank" class="text-decoration-none">${post.title}</a>
                    </div>
                  </td>
                  <td>${post.authorNickname}</td>
                  <td>${post.formattedCreatedAt}</td>
                  <td>${post.viewCount}</td>
                  <td>${post.likeCount}</td>
                  <td>${post.commentCount}</td>
                  <td>
                    <button type="button" class="btn btn-danger btn-sm btn-custom"
                            onclick="deletePost(${post.communityId}, '${post.title}')">
                      <i class="fas fa-trash"></i> 삭제
                    </button>
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
                    <a class="page-link" href="?action=posts&page=${currentPage-1}&category=${category}&searchType=${searchType}&searchKeyword=${searchKeyword}">이전</a>
                  </li>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                  <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="?action=posts&page=${i}&category=${category}&searchType=${searchType}&searchKeyword=${searchKeyword}">${i}</a>
                  </li>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                  <li class="page-item">
                    <a class="page-link" href="?action=posts&page=${currentPage+1}&category=${category}&searchType=${searchType}&searchKeyword=${searchKeyword}">다음</a>
                  </li>
                </c:if>
              </ul>
            </nav>
          </c:if>
        </c:when>
        <c:otherwise>
          <div class="text-center py-5 text-muted">
            <i class="fas fa-file-alt fa-3x mb-3"></i>
            <p>게시글이 없습니다.</p>
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
        <h5 class="modal-title">게시글 삭제 확인</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p id="deleteMessage"></p>
        <div class="alert alert-warning">
          <strong>주의:</strong> 게시글을 삭제하면 해당 게시글의 모든 댓글과 좋아요도 함께 삭제됩니다.
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin" style="display: inline;">
          <input type="hidden" name="action" value="deletePost">
          <input type="hidden" name="postId" id="deletePostId">
          <button type="submit" class="btn btn-danger">삭제</button>
        </form>
      </div>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />

<script>
  function deletePost(postId, title) {
    document.getElementById('deletePostId').value = postId;
    document.getElementById('deleteMessage').textContent =
            `정말로 "${title}" 게시글을 삭제하시겠습니까?`;

    // Bootstrap 5 모달 사용
    const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
    modal.show();
  }

  // 삭제 폼 제출 시 확인
  document.addEventListener('DOMContentLoaded', function() {
    const deleteForm = document.getElementById('deleteForm');
    if (deleteForm) {
      deleteForm.addEventListener('submit', function(e) {
        // 추가 확인 (선택사항)
        if (!confirm('정말로 삭제하시겠습니까?')) {
          e.preventDefault();
          return false;
        }
      });
    }
  });

  // 성공/오류 메시지 표시
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.get('success') === 'post_deleted') {
    alert('게시글이 성공적으로 삭제되었습니다.');
  } else if (urlParams.get('error') === 'delete_failed') {
    alert('게시글 삭제에 실패했습니다.');
  } else if (urlParams.get('error') === 'invalid_id') {
    alert('잘못된 게시글 ID입니다.');
  }
</script>
