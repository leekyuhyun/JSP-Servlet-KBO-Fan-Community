<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0">
            💬 댓글 <span class="badge bg-primary">${community.commentCount}</span>
        </h5>
    </div>

    <div class="card-body">
        <!-- 댓글 작성 폼 -->
        <c:if test="${not empty sessionScope.user}">
            <form method="post" action="${pageContext.request.contextPath}/community" class="mb-4">
                <input type="hidden" name="action" value="comment">
                <input type="hidden" name="communityId" value="${community.communityId}">

                <div class="mb-3">
                    <label for="commentContent" class="form-label">댓글 작성</label>
                    <textarea name="content" id="commentContent" class="form-control" rows="3"
                              placeholder="댓글을 입력하세요..." required maxlength="1000"></textarea>
                    <div class="form-text">
                        <span id="commentLength">0</span> / 1,000자
                    </div>
                </div>

                <div class="text-end">
                    <button type="submit" class="btn btn-primary">
                        💬 댓글 작성
                    </button>
                </div>
            </form>

            <hr>
        </c:if>

        <c:if test="${empty sessionScope.user}">
            <div class="alert alert-info text-center">
                ℹ️ 댓글을 작성하려면 <a href="${pageContext.request.contextPath}/login.jsp">로그인</a>이 필요합니다.
            </div>
            <hr>
        </c:if>

        <!-- 댓글 목록 -->
        <div id="commentsList">
            <c:choose>
                <c:when test="${empty comments}">
                    <div class="text-center py-4">
                        <span class="display-4">💬</span>
                        <p class="text-muted mt-2">아직 댓글이 없습니다.<br>첫 번째 댓글을 작성해보세요!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="comment" items="${comments}" varStatus="status">
                        <div class="comment-item ${status.last ? '' : 'border-bottom'}" id="comment-${comment.commentId}">
                            <div class="d-flex mb-3">
                                <div class="flex-shrink-0">
                                    <span class="fs-3 text-muted">👤</span>
                                </div>
                                <div class="flex-grow-1 ms-3">
                                    <!-- 댓글 헤더 -->
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <strong class="text-primary">${comment.commentAuthorNickname}</strong>
                                            <c:if test="${not empty comment.commentAuthorTeamName}">
                                                <span class="badge bg-light text-dark ms-2">${comment.commentAuthorTeamName}</span>
                                            </c:if>
                                            <br>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${comment.commentCreatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                                                <c:if test="${comment.commentUpdatedAt != null}">
                                                    <span class="text-warning">(수정됨)</span>
                                                </c:if>
                                            </small>
                                        </div>

                                        <!-- 댓글 액션 버튼 -->
                                        <c:if test="${sessionScope.user.userId == comment.commentAuthorId}">
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                                        data-bs-toggle="dropdown" aria-expanded="false">
                                                    ⋯
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li>
                                                        <button class="dropdown-item" onclick="editComment(${comment.commentId})">
                                                            ✏️ 수정
                                                        </button>
                                                    </li>
                                                    <li>
                                                        <button class="dropdown-item text-danger" onclick="deleteComment(${comment.commentId}, ${community.communityId})">
                                                            🗑️ 삭제
                                                        </button>
                                                    </li>
                                                </ul>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- 댓글 내용 -->
                                    <div class="comment-content" id="content-${comment.commentId}">
                                        <p class="mb-2">${comment.commentContent.replaceAll("\\n", "<br>")}</p>
                                    </div>

                                    <!-- 댓글 수정 폼 (숨김) -->
                                    <div class="comment-edit-form d-none" id="edit-form-${comment.commentId}">
                                        <form onsubmit="updateComment(event, ${comment.commentId}, ${community.communityId})">
                                            <div class="mb-2">
                                                <textarea class="form-control" rows="3" required maxlength="1000">${comment.commentContent}</textarea>
                                            </div>
                                            <div class="text-end">
                                                <button type="button" class="btn btn-sm btn-secondary me-2" onclick="cancelEdit(${comment.commentId})">
                                                    취소
                                                </button>
                                                <button type="submit" class="btn btn-sm btn-primary">
                                                    수정완료
                                                </button>
                                            </div>
                                        </form>
                                    </div>

                                    <!-- 댓글 좋아요 -->
                                    <div class="comment-actions mt-2">
                                        <c:if test="${not empty sessionScope.user}">
                                            <button class="btn btn-sm ${comment.commentLikedByCurrentUser ? 'btn-danger' : 'btn-outline-danger'}"
                                                    onclick="toggleCommentLike(${comment.commentId})"
                                                    id="commentLikeBtn-${comment.commentId}">
                                                <span>${comment.commentLikedByCurrentUser ? '❤️' : '🤍'}</span>
                                                <span id="commentLikeCount-${comment.commentId}">${comment.commentLikeCount}</span>
                                            </button>
                                        </c:if>
                                        <c:if test="${empty sessionScope.user && comment.commentLikeCount > 0}">
                                            <span class="text-muted">
                                                ❤️ ${comment.commentLikeCount}
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- 댓글 삭제용 폼 -->
<form method="post" action="${pageContext.request.contextPath}/community" id="commentDeleteForm" style="display: none;">
    <input type="hidden" name="action" value="comment_delete">
    <input type="hidden" name="commentId" id="deleteCommentId">
    <input type="hidden" name="communityId" value="${community.communityId}">
</form>

<script>
    // 댓글 글자 수 카운터
    document.addEventListener('DOMContentLoaded', function() {
        const commentTextarea = document.getElementById('commentContent');
        const commentLength = document.getElementById('commentLength');

        if (commentTextarea && commentLength) {
            function updateCommentLength() {
                const length = commentTextarea.value.length;
                commentLength.textContent = length;

                if (length > 1000) {
                    commentLength.style.color = 'red';
                    commentTextarea.value = commentTextarea.value.substring(0, 1000);
                    commentLength.textContent = 1000;
                } else if (length > 900) {
                    commentLength.style.color = 'orange';
                } else {
                    commentLength.style.color = 'inherit';
                }
            }

            commentTextarea.addEventListener('input', updateCommentLength);
            updateCommentLength();
        }
    });

    // 댓글 수정
    function editComment(commentId) {
        const contentDiv = document.getElementById('content-' + commentId);
        const editForm = document.getElementById('edit-form-' + commentId);

        contentDiv.classList.add('d-none');
        editForm.classList.remove('d-none');
    }

    // 댓글 수정 취소
    function cancelEdit(commentId) {
        const contentDiv = document.getElementById('content-' + commentId);
        const editForm = document.getElementById('edit-form-' + commentId);

        contentDiv.classList.remove('d-none');
        editForm.classList.add('d-none');
    }

    // 댓글 수정 처리
    function updateComment(event, commentId, communityId) {
        event.preventDefault();
        alert('댓글 수정 기능은 추후 구현 예정입니다.');
    }

    // 댓글 삭제
    function deleteComment(commentId, communityId) {
        if (confirm('정말 이 댓글을 삭제하시겠습니까?')) {
            document.getElementById('deleteCommentId').value = commentId;
            document.getElementById('commentDeleteForm').submit();
        }
    }

    // 댓글 좋아요 토글
    function toggleCommentLike(commentId) {
        fetch('${pageContext.request.contextPath}/community', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=comment_like&commentId=' + commentId
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload(); // 간단한 구현을 위해 페이지 새로고침
                } else {
                    alert(data.message || '좋아요 처리에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('좋아요 처리 중 오류가 발생했습니다.');
            });
    }
</script>

<style>
    .comment-item {
        padding: 1rem 0;
    }

    .comment-item:last-child {
        border-bottom: none !important;
    }

    .comment-content p {
        word-wrap: break-word;
        white-space: pre-wrap;
    }

    .comment-actions .btn {
        font-size: 0.875rem;
    }

    .dropdown-toggle::after {
        display: none;
    }
</style>