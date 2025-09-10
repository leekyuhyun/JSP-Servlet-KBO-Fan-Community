<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="${community.title}" />
    <jsp:param name="activeMenu" value="community" />
    <jsp:param name="customCSS" value="
        <style>
            .post-image {
                max-width: 100%;
                height: auto;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin: 20px 0;
                cursor: pointer;
                transition: transform 0.3s ease;
            }

            .post-image:hover {
                transform: scale(1.02);
            }

            .content-area {
                line-height: 1.8;
                font-size: 1.1rem;
                color: #333;
            }

            .post-meta {
                background: #f8f9fa;
                border-radius: 10px;
                padding: 15px;
                margin-bottom: 20px;
            }

            .author-info {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .author-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: bold;
            }

            .stats-info {
                display: flex;
                gap: 15px;
                align-items: center;
            }

            .stat-item {
                display: flex;
                align-items: center;
                gap: 5px;
                color: #6c757d;
            }

            .like-section {
                background: #f8f9fa;
                border-radius: 15px;
                padding: 20px;
                text-align: center;
                margin: 30px 0;
            }

            .btn-like {
                border-radius: 25px;
                padding: 10px 30px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-like:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            }

            .image-modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.9);
                cursor: pointer;
            }

            .modal-content {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                max-width: 90%;
                max-height: 90%;
            }

            .close-modal {
                position: absolute;
                top: 15px;
                right: 35px;
                color: #f1f1f1;
                font-size: 40px;
                font-weight: bold;
                cursor: pointer;
            }

            .close-modal:hover {
                color: #bbb;
            }

            .image-error {
                background: #f8f9fa;
                border: 2px dashed #dee2e6;
                border-radius: 10px;
                padding: 20px;
                text-align: center;
                color: #6c757d;
                margin: 20px 0;
            }
        </style>
    " />
</jsp:include>

<div class="container mt-4">
    <!-- 게시글 상세 -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <span class="badge
                                <c:choose>
                                    <c:when test="${community.category == 'free'}">bg-secondary</c:when>
                                    <c:when test="${community.category == 'analysis'}">bg-success</c:when>
                                    <c:when test="${community.category == 'news'}">bg-info</c:when>
                                    <c:when test="${community.category == 'humor'}">bg-warning</c:when>
                                    <c:when test="${community.category == 'question'}">bg-danger</c:when>
                                    <c:when test="${community.category == 'trade'}">bg-dark</c:when>
                                    <c:otherwise>bg-light text-dark</c:otherwise>
                                </c:choose> me-2">
                                <c:choose>
                                    <c:when test="${community.category == 'free'}">자유게시판</c:when>
                                    <c:when test="${community.category == 'analysis'}">경기분석</c:when>
                                    <c:when test="${community.category == 'news'}">뉴스/소식</c:when>
                                    <c:when test="${community.category == 'humor'}">유머</c:when>
                                    <c:when test="${community.category == 'question'}">질문</c:when>
                                    <c:when test="${community.category == 'trade'}">트레이드</c:when>
                                    <c:otherwise>기타</c:otherwise>
                                </c:choose>
                            </span>
                            <h4 class="d-inline mb-0">${community.title}</h4>
                            <c:if test="${not empty community.imagePath}">
                                <i class="bi bi-image text-success ms-2" title="이미지 포함"></i>
                            </c:if>
                        </div>
                        <div class="col-md-4 text-end">
                            <a href="${pageContext.request.contextPath}/community?action=list" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-list"></i> 목록
                            </a>
                            <c:if test="${sessionScope.user.userId == community.authorId}">
                                <a href="${pageContext.request.contextPath}/community?action=edit&id=${community.communityId}" class="btn btn-outline-primary btn-sm">
                                    <i class="bi bi-pencil"></i> 수정
                                </a>
                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="deletePost()">
                                    <i class="bi bi-trash"></i> 삭제
                                </button>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="card-body">
                    <!-- 작성자 정보 및 통계 -->
                    <div class="post-meta">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <div class="author-info">
                                    <div class="author-avatar">
                                        ${community.authorNickname.substring(0, 1)}
                                    </div>
                                    <div>
                                        <strong>${community.authorNickname}</strong>
                                        <c:if test="${not empty community.authorTeamName}">
                                            <span class="badge bg-light text-dark ms-2">${community.authorTeamName}</span>
                                        </c:if>
                                        <br>
                                        <small class="text-muted">
                                            <i class="bi bi-clock"></i>
                                            <fmt:formatDate value="${community.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                            <c:if test="${community.updatedAt != null}">
                                                (수정됨: <fmt:formatDate value="${community.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss"/>)
                                            </c:if>
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 text-end">
                                <div class="stats-info">
                                    <div class="stat-item">
                                        <i class="bi bi-eye"></i>
                                        <span>${community.viewCount}</span>
                                    </div>
                                    <div class="stat-item">
                                        <i class="bi bi-heart"></i>
                                        <span>${community.likeCount}</span>
                                    </div>
                                    <div class="stat-item">
                                        <i class="bi bi-chat"></i>
                                        <span>${community.commentCount}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 게시글 내용 -->
                    <div class="content-area">
                        ${community.content.replaceAll("\\n", "<br>")}
                    </div>

                    <!-- 이미지 표시 (수정된 경로) -->
                    <c:if test="${not empty community.imagePath}">
                        <div class="text-center my-4">
                            <img src="${pageContext.request.contextPath}/images/${community.imagePath}"
                                 class="post-image"
                                 alt="게시글 이미지"
                                 onclick="openImageModal(this.src)"
                                 onerror="this.parentElement.innerHTML='<div class=\\'image-error\\'><i class=\\'bi bi-image\\'></i><br>이미지를 불러올 수 없습니다.</div>'">
                        </div>
                    </c:if>

                    <!-- 좋아요 버튼 -->
                    <div class="like-section">
                        <c:if test="${not empty sessionScope.user}">
                            <button type="button" class="btn btn-like ${community.likedByCurrentUser ? 'btn-danger' : 'btn-outline-danger'}"
                                    onclick="toggleLike(${community.communityId})" id="likeBtn">
                                <span id="heartIcon">
                                    <i class="bi ${community.likedByCurrentUser ? 'bi-heart-fill' : 'bi-heart'}"></i>
                                </span>
                                좋아요 <span id="likeCount">${community.likeCount}</span>
                            </button>
                        </c:if>
                        <c:if test="${empty sessionScope.user}">
                            <p class="text-muted mb-0">
                                <i class="bi bi-heart"></i> 좋아요 ${community.likeCount}개
                                <br>
                                <small>로그인하면 좋아요를 누를 수 있습니다.</small>
                            </p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 댓글 -->
    <div class="row mt-4" id="comments">
        <div class="col-12">
            <jsp:include page="comments.jsp" />
        </div>
    </div>
</div>

<!-- 이미지 모달 -->
<div id="imageModal" class="image-modal" onclick="closeImageModal()">
    <span class="close-modal" onclick="closeImageModal()">&times;</span>
    <img class="modal-content" id="modalImage">
</div>

<!-- 삭제 처리용 -->
<form method="post" action="${pageContext.request.contextPath}/community" id="deleteForm">
    <input type="hidden" name="action" value="delete" />
    <input type="hidden" name="id" value="${community.communityId}" />
</form>

<script>
    function deletePost() {
        if (confirm("정말 삭제하시겠습니까?")) {
            document.getElementById("deleteForm").submit();
        }
    }

    function toggleLike(communityId) {
        fetch('${pageContext.request.contextPath}/community', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=like&communityId=' + communityId
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const likeBtn = document.getElementById('likeBtn');
                    const likeCount = document.getElementById('likeCount');
                    const heartIcon = document.getElementById('heartIcon');

                    likeCount.textContent = data.likeCount;

                    if (data.isLiked) {
                        likeBtn.className = 'btn btn-like btn-danger';
                        heartIcon.innerHTML = '<i class="bi bi-heart-fill"></i>';
                    } else {
                        likeBtn.className = 'btn btn-like btn-outline-danger';
                        heartIcon.innerHTML = '<i class="bi bi-heart"></i>';
                    }
                } else {
                    alert(data.message || '좋아요 처리에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('좋아요 처리 중 오류가 발생했습니다.');
            });
    }

    // 이미지 모달 관련 함수
    function openImageModal(imageSrc) {
        const modal = document.getElementById('imageModal');
        const modalImg = document.getElementById('modalImage');
        modal.style.display = 'block';
        modalImg.src = imageSrc;
    }

    function closeImageModal() {
        document.getElementById('imageModal').style.display = 'none';
    }

    // ESC 키로 모달 닫기
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeImageModal();
        }
    });
</script>

<jsp:include page="../includes/footer.jsp" />