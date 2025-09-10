<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="커뮤니티" />
    <jsp:param name="activeMenu" value="community" />
    <jsp:param name="customCSS" value="
        <style>
            .image-indicator {
                color: #28a745;
                font-size: 1.1rem;
                margin-right: 5px;
            }

            .post-title {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .post-meta {
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
            }

            .table td {
                vertical-align: middle;
            }

            .category-badge {
                font-size: 0.8rem;
                padding: 4px 8px;
            }

            .team-badge {
                font-size: 0.75rem;
                padding: 2px 6px;
            }
        </style>
    " />
</jsp:include>

<div class="container mt-4">
    <!-- 페이지 헤더 -->
    <div class="row mb-4">
        <div class="col-md-8">
            <h2 class="mb-3">
                💬 커뮤니티
                <c:if test="${category != 'all'}">
                    <span class="badge bg-primary ms-2">
                        <c:choose>
                            <c:when test="${category == 'free'}">자유게시판</c:when>
                            <c:when test="${category == 'analysis'}">경기분석</c:when>
                            <c:when test="${category == 'news'}">뉴스/소식</c:when>
                            <c:when test="${category == 'humor'}">유머</c:when>
                            <c:when test="${category == 'question'}">질문</c:when>
                            <c:when test="${category == 'trade'}">트레이드</c:when>
                            <c:otherwise>기타</c:otherwise>
                        </c:choose>
                    </span>
                </c:if>
            </h2>
            <p class="text-muted">
                총 <strong>${totalCount}</strong>개의 게시글이 있습니다.
                <c:if test="${not empty searchKeyword}">
                    '<strong>${searchKeyword}</strong>' 검색 결과
                </c:if>
            </p>
        </div>
        <div class="col-md-4 text-end">
            <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/community?action=write" class="btn btn-primary">
                    <i class="bi bi-pencil-square"></i> 글쓰기
                </a>
            </c:if>
        </div>
    </div>

    <!-- 카테고리 탭 -->
    <div class="row mb-4">
        <div class="col-12">
            <ul class="nav nav-pills">
                <li class="nav-item">
                    <a class="nav-link ${category == 'all' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/community?action=list&category=all">
                        📋 전체
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${category == 'free' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/community?action=list&category=free">
                        💬 자유게시판
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${category == 'analysis' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/community?action=list&category=analysis">
                        📊 경기분석
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${category == 'news' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/community?action=list&category=news">
                        📰 뉴스/소식
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${category == 'humor' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/community?action=list&category=humor">
                        😄 유머
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${category == 'question' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/community?action=list&category=question">
                        ❓ 질문
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${category == 'trade' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/community?action=list&category=trade">
                        🔄 트레이드
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <!-- 검색 폼 -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/community" class="row g-3">
                        <input type="hidden" name="action" value="list">
                        <input type="hidden" name="category" value="${category}">
                        <div class="col-md-3">
                            <select name="searchType" class="form-select">
                                <option value="all" ${searchType == 'all' ? 'selected' : ''}>전체</option>
                                <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                                <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
                                <option value="author" ${searchType == 'author' ? 'selected' : ''}>작성자</option>
                            </select>
                        </div>

                        <div class="col-md-7">
                            <input type="text" name="searchKeyword" class="form-control"
                                   placeholder="검색어를 입력하세요" value="${searchKeyword}">
                        </div>

                        <div class="col-md-2">
                            <button type="submit" class="btn btn-outline-primary w-100">
                                🔍 검색
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- 게시글 목록 -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty communities}">
                            <div class="text-center py-5">
                                <span class="display-1">📭</span>
                                <h4 class="mt-3 text-muted">게시글이 없습니다</h4>
                                <p class="text-muted">첫 번째 게시글을 작성해보세요!</p>
                                <c:if test="${not empty sessionScope.user}">
                                    <a href="${pageContext.request.contextPath}/community?action=write" class="btn btn-primary">
                                        ✏️ 글쓰기
                                    </a>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                    <tr>
                                        <th width="8%" class="text-center">번호</th>
                                        <th width="12%" class="text-center">카테고리</th>
                                        <th width="45%">제목</th>
                                        <th width="15%" class="text-center">작성자</th>
                                        <th width="8%" class="text-center">조회</th>
                                        <th width="12%" class="text-center">작성일</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="community" items="${communities}" varStatus="status">
                                        <tr>
                                            <td class="text-center">
                                                    ${totalCount - (currentPage - 1) * 15 - status.index}
                                            </td>
                                            <td class="text-center">
                                                <span class="badge category-badge
                                                    <c:choose>
                                                        <c:when test="${community.category == 'free'}">bg-secondary</c:when>
                                                        <c:when test="${community.category == 'analysis'}">bg-success</c:when>
                                                        <c:when test="${community.category == 'news'}">bg-info</c:when>
                                                        <c:when test="${community.category == 'humor'}">bg-warning</c:when>
                                                        <c:when test="${community.category == 'question'}">bg-danger</c:when>
                                                        <c:when test="${community.category == 'trade'}">bg-dark</c:when>
                                                        <c:otherwise>bg-light text-dark</c:otherwise>
                                                    </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${community.category == 'free'}">자유</c:when>
                                                        <c:when test="${community.category == 'analysis'}">분석</c:when>
                                                        <c:when test="${community.category == 'news'}">뉴스</c:when>
                                                        <c:when test="${community.category == 'humor'}">유머</c:when>
                                                        <c:when test="${community.category == 'question'}">질문</c:when>
                                                        <c:when test="${community.category == 'trade'}">트레이드</c:when>
                                                        <c:otherwise>기타</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="post-title">
                                                    <!-- 이미지 아이콘 표시 -->
                                                    <c:if test="${not empty community.imagePath}">
                                                        <i class="bi bi-image image-indicator" title="이미지 포함"></i>
                                                    </c:if>

                                                    <a href="${pageContext.request.contextPath}/community?action=view&id=${community.communityId}"
                                                       class="text-decoration-none fw-medium flex-grow-1">
                                                            ${community.title}
                                                    </a>
                                                </div>

                                                <div class="post-meta mt-1">
                                                    <c:if test="${community.commentCount > 0}">
                                                        <span class="badge bg-primary">${community.commentCount}</span>
                                                    </c:if>
                                                    <c:if test="${community.likeCount > 0}">
                                                        <small class="text-danger">
                                                            <i class="bi bi-heart-fill"></i> ${community.likeCount}
                                                        </small>
                                                    </c:if>
                                                    <c:if test="${not empty community.imagePath}">
                                                        <small class="text-success">
                                                            <i class="bi bi-image"></i> 이미지
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </td>

                                            <td class="text-center">
                                                <div class="d-flex align-items-center justify-content-center flex-column">
                                                    <span class="fw-medium">${community.authorNickname}</span>
                                                    <c:if test="${not empty community.authorTeamName}">
                                                        <small class="badge bg-light text-dark team-badge">${community.authorTeamName}</small>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <small class="text-muted">
                                                    <i class="bi bi-eye"></i> ${community.viewCount}
                                                </small>
                                            </td>
                                            <td class="text-center">
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${community.createdAt}" pattern="MM-dd HH:mm"/>
                                                </small>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- 페이지네이션 -->
    <c:if test="${totalPages > 1}">
        <div class="row mt-4">
            <div class="col-12">
                <nav aria-label="게시글 페이지네이션">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/community?action=list&category=${category}&searchType=${searchType}&searchKeyword=${searchKeyword}&page=${currentPage - 1}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>

                        <!-- 페이지 번호 -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/community?action=list&category=${category}&searchType=${searchType}&searchKeyword=${searchKeyword}&page=${pageNum}">
                                        ${pageNum}
                                </a>
                            </li>
                        </c:forEach>

                        <!-- 다음 페이지 -->
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/community?action=list&category=${category}&searchType=${searchType}&searchKeyword=${searchKeyword}&page=${currentPage + 1}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="../includes/footer.jsp" />