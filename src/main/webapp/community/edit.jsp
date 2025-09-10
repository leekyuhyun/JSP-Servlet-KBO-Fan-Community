<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="게시글 수정" />
    <jsp:param name="activeMenu" value="community" />
</jsp:include>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header">
                    <h4 class="mb-0">
                        <i class="bi bi-pencil me-2"></i>게시글 수정
                    </h4>
                </div>

                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            <i class="bi bi-exclamation-triangle me-2"></i>${error}
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/community/" id="editForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${community.communityId}">

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="category" class="form-label">카테고리 <span class="text-danger">*</span></label>
                                <select name="category" id="category" class="form-select" required>
                                    <option value="">카테고리를 선택하세요</option>
                                    <option value="free" ${community.category == 'free' ? 'selected' : ''}>자유게시판</option>
                                    <option value="analysis" ${community.category == 'analysis' ? 'selected' : ''}>경기분석</option>
                                    <option value="news" ${community.category == 'news' ? 'selected' : ''}>뉴스/소식</option>
                                    <option value="humor" ${community.category == 'humor' ? 'selected' : ''}>유머</option>
                                    <option value="question" ${community.category == 'question' ? 'selected' : ''}>질문</option>
                                    <option value="trade" ${community.category == 'trade' ? 'selected' : ''}>트레이드</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="title" class="form-label">제목 <span class="text-danger">*</span></label>
                            <input type="text" name="title" id="title" class="form-control"
                                   placeholder="제목을 입력하세요" value="${community.title}" required maxlength="255">
                            <div class="form-text">최대 255자까지 입력 가능합니다.</div>
                        </div>

                        <div class="mb-4">
                            <label for="content" class="form-label">내용 <span class="text-danger">*</span></label>
                            <textarea name="content" id="content" class="form-control" rows="15"
                                      placeholder="내용을 입력하세요" required>${community.content}</textarea>
                            <div class="form-text">
                                <span id="contentLength">0</span> / 10,000자
                            </div>
                        </div>

                        <div class="alert alert-info">
                            <i class="bi bi-info-circle me-2"></i>
                            <strong>수정 안내:</strong> 게시글을 수정하면 수정 시간이 표시됩니다.
                        </div>

                        <hr>

                        <div class="text-end">
                            <a href="${pageContext.request.contextPath}/community/?action=view&id=${community.communityId}" class="btn btn-secondary me-2">
                                <i class="bi bi-x-circle me-1"></i>취소
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle me-1"></i>수정완료
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const contentTextarea = document.getElementById('content');
        const contentLength = document.getElementById('contentLength');
        const maxLength = 10000;

        // 글자 수 카운터
        function updateContentLength() {
            const length = contentTextarea.value.length;
            contentLength.textContent = length;

            if (length > maxLength) {
                contentLength.style.color = 'red';
                contentTextarea.value = contentTextarea.value.substring(0, maxLength);
                contentLength.textContent = maxLength;
            } else if (length > maxLength * 0.9) {
                contentLength.style.color = 'orange';
            } else {
                contentLength.style.color = 'inherit';
            }
        }

        contentTextarea.addEventListener('input', updateContentLength);
        updateContentLength(); // 초기 로드 시 실행

        // 폼 제출 전 유효성 검사
        document.getElementById('editForm').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const content = contentTextarea.value.trim();
            const category = document.getElementById('category').value;

            if (!category) {
                alert('카테고리를 선택해주세요.');
                e.preventDefault();
                return;
            }

            if (!title) {
                alert('제목을 입력해주세요.');
                e.preventDefault();
                return;
            }

            if (!content) {
                alert('내용을 입력해주세요.');
                e.preventDefault();
                return;
            }

            if (content.length > maxLength) {
                alert('내용이 너무 깁니다. ' + maxLength + '자 이내로 작성해주세요.');
                e.preventDefault();
                return;
            }
        });
    });
</script>

<jsp:include page="../includes/footer.jsp" />