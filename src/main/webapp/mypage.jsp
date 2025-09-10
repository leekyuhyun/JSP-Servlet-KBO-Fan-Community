<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.kbofan.dto.User" %>
<%@ page import="com.kbofan.dto.Community" %>
<%@ page import="com.kbofan.dto.GameRecord" %>
<%@ page import="com.kbofan.dao.MyPageDAO" %>
<%@ page import="java.util.List" %>
<%
    // 로그인 체크
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // DAO 인스턴스 생성
    MyPageDAO myPageDAO = new MyPageDAO();

    // 사용자 활동 통계 조회
    int[] stats = myPageDAO.getUserActivityStats(user.getUserId());
    int postCount = stats[0];
    int commentCount = stats[1];
    int gameCount = stats[2];

    // 모든 게시글 조회 (제한 없음)
    List<Community> allPosts = myPageDAO.getUserPosts(user.getUserId(), 0); // 0은 제한 없음을 의미

    // 최근 좋아요한 게시글 조회 (5개)
    List<Community> likedPosts = myPageDAO.getLikedPosts(user.getUserId(), 5);

    // 모든 댓글 조회 (제한 없음)
    List<Community> allComments = myPageDAO.getUserComments(user.getUserId(), 0); // 0은 제한 없음을 의미

    // 최근 직관 기록 조회 (3개)
    List<GameRecord> recentGames = myPageDAO.getUserGameRecords(user.getUserId(), 3);

    // 탭 파라미터 확인
    String activeTab = request.getParameter("tab");
    if (activeTab == null) {
        activeTab = "posts";
    }
%>

<!-- 헤더 포함 -->
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="마이페이지" />
    <jsp:param name="activeMenu" value="mypage" />
    <jsp:param name="customCSS" value="
        <style>
            .profile-card {
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                padding: 30px;
                background: white;
                color: #333;
                text-align: center;
                margin-bottom: 20px;
            }

            .profile-image {
                width: 120px;
                height: 120px;
                margin-bottom: 20px;
                object-fit: contain;
            }

            .stats-card {
                background: white;
                border-radius: 15px;
                padding: 20px;
                text-align: center;
                margin-bottom: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .stats-number {
                font-size: 2.5rem;
                font-weight: bold;
                color: #6c7ae0;
                margin-bottom: 5px;
            }

            .stats-label {
                color: #6c757d;
                font-weight: 500;
            }

            .content-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .nav-tabs {
                border-bottom: none;
                background: #f8f9fa;
                padding: 10px 20px 0;
            }

            .nav-tabs .nav-link {
                border: none;
                border-radius: 10px 10px 0 0;
                margin-right: 5px;
                color: #6c757d;
                font-weight: 500;
            }

            .nav-tabs .nav-link.active {
                background: white;
                color: #6c7ae0;
                font-weight: 600;
            }

            .tab-content {
                padding: 30px;
            }

            .post-item {
                border-bottom: 1px solid #eee;
                padding: 20px 0;
                transition: background-color 0.3s ease;
            }

            .post-item:hover {
                background-color: #f8f9fa;
                border-radius: 10px;
                margin: 0 -15px;
                padding: 20px 15px;
            }

            .post-item:last-child {
                border-bottom: none;
            }

            .badge-category {
                font-size: 0.8rem;
                padding: 5px 10px;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }

            .empty-state i {
                font-size: 3rem;
                margin-bottom: 20px;
                opacity: 0.5;
            }

            .record-form {
                background: #f8f9fa;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 30px;
                display: none;
            }

            .record-item {
                background: white;
                border-radius: 15px;
                padding: 20px;
                margin-bottom: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
            }

            .record-item:hover {
                transform: translateY(-3px);
            }

            .game-score {
                font-size: 1.5rem;
                font-weight: bold;
                margin: 10px 0;
            }

            .winner-badge {
                background: linear-gradient(45deg, #28a745, #20c997);
                color: white;
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: 600;
            }

            .draw-badge {
                background: linear-gradient(45deg, #ffc107, #fd7e14);
                color: white;
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: 600;
            }

            .btn-browse {
                padding: 8px 16px;
                font-size: 0.9rem;
            }

            .btn-browse i {
                font-size: 0.8rem;
                margin-right: 5px;
            }

            .team-love {
                color: #dc3545;
                margin-right: 5px;
            }

            .profile-edit {
                margin-left: 5px;
                font-size: 0.9rem;
            }

            .stat-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                padding: 20px;
                text-align: center;
                margin-bottom: 15px;
            }

            .stat-number {
                font-size: 3rem;
                font-weight: bold;
                color: #6c7ae0;
                margin-bottom: 5px;
            }

            .stat-label {
                color: #6c757d;
                font-size: 1rem;
            }

            .nav-tabs .nav-link i {
                font-size: 0.9rem;
                margin-right: 5px;
            }

            .post-item small i {
                font-size: 0.8rem;
            }
        </style>
    " />
</jsp:include>

<body class="bg-light">

<div class="container mt-5">
    <div class="row">
        <!-- 프로필 사이드바 -->
        <div class="col-md-4">
            <!-- 프로필 카드 -->
            <div class="profile-card">
                <c:choose>
                    <c:when test="${not empty user.teamLogo}">
                        <img src="${user.teamLogo}" class="profile-image" alt="Team Logo">
                    </c:when>
                    <c:otherwise>
                        <div class="profile-image d-flex align-items-center justify-content-center">
                            <i class="bi bi-person fs-1 text-primary"></i>
                        </div>
                    </c:otherwise>
                </c:choose>

                <h4 class="mb-2"><%= user.getNickname() %></h4>
                <p class="mb-1">@<%= user.getLoginId() %></p>
                <p class="mb-3"><%= user.getEmail() %></p>

                <div class="d-flex justify-content-center align-items-center mb-2">
                    <c:if test="${not empty user.teamName}">
                        <span><i class="bi bi-heart-fill team-love"></i> <%= user.getTeamName() %></span>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/updateProfile" class="text-decoration-none ms-3" target="_blank">
                        <i class="bi bi-pencil profile-edit"></i> 프로필 수정
                    </a>
                </div>
            </div>

            <!-- 통계 카드들 -->
            <div class="stat-card">
                <div class="stat-number"><%= postCount %></div>
                <div class="stat-label">작성한 게시글</div>
            </div>

            <div class="stat-card">
                <div class="stat-number"><%= commentCount %></div>
                <div class="stat-label">작성한 댓글</div>
            </div>

            <div class="stat-card">
                <div class="stat-number"><%= gameCount %></div>
                <div class="stat-label">직관 경기</div>
            </div>
        </div>

        <!-- 메인 콘텐츠 -->
        <div class="col-md-8">
            <div class="content-card">
                <ul class="nav nav-tabs" id="mypageTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= "posts".equals(activeTab) ? "active" : "" %>"
                                data-bs-toggle="tab" data-bs-target="#posts" type="button">
                            <i class="bi bi-file-text"></i> 내 게시글 (<%= postCount %>)
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= "likes".equals(activeTab) ? "active" : "" %>"
                                data-bs-toggle="tab" data-bs-target="#likes" type="button">
                            <i class="bi bi-heart"></i> 좋아요한 글 (<%= likedPosts.size() %>)
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= "comments".equals(activeTab) ? "active" : "" %>"
                                data-bs-toggle="tab" data-bs-target="#comments" type="button">
                            <i class="bi bi-chat"></i> 내 댓글 (<%= commentCount %>)
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= "games".equals(activeTab) ? "active" : "" %>"
                                data-bs-toggle="tab" data-bs-target="#games" type="button">
                            <i class="bi bi-calendar-event"></i> 직관 일지 (<%= gameCount %>)
                        </button>
                    </li>
                </ul>

                <div class="tab-content">
                    <!-- 내 게시글 탭 -->
                    <div class="tab-pane fade <%= "posts".equals(activeTab) ? "show active" : "" %>" id="posts">
                        <h5 class="mb-4"><i class="bi bi-file-text text-primary"></i> 내가 작성한 게시글</h5>

                        <% if (allPosts.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="bi bi-file-earmark-text"></i>
                            <h5>아직 작성한 게시글이 없습니다</h5>
                            <p>첫 번째 게시글을 작성해보세요!</p>
                            <a href="${pageContext.request.contextPath}/community?action=write" class="btn btn-primary">
                                <i class="bi bi-pencil"></i> 게시글 작성하기
                            </a>
                        </div>
                        <% } else { %>
                        <% for (Community post : allPosts) { %>
                        <div class="post-item">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <span class="badge badge-category bg-secondary me-2"><%= post.getCategoryDisplayName() %></span>
                                    <h6 class="mb-2">
                                        <a href="${pageContext.request.contextPath}/community?action=view&id=<%= post.getCommunityId() %>"
                                           class="text-decoration-none text-dark">
                                            <%= post.getTitle() %>
                                        </a>
                                    </h6>
                                    <small class="text-muted">
                                        <i class="bi bi-clock"></i> <%= post.getFormattedCreatedAt() %> |
                                        <i class="bi bi-eye"></i> <%= post.getViewCount() %> |
                                        <i class="bi bi-heart"></i> <%= post.getLikeCount() %> |
                                        <i class="bi bi-chat"></i> <%= post.getCommentCount() %>
                                    </small>
                                </div>
                                <div class="ms-3">
                                    <a href="${pageContext.request.contextPath}/community?action=view&id=<%= post.getCommunityId() %>"
                                       class="btn btn-sm btn-outline-primary">보기</a>
                                    <a href="${pageContext.request.contextPath}/community?action=edit&id=<%= post.getCommunityId() %>"
                                       class="btn btn-sm btn-outline-secondary">수정</a>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        <% } %>
                    </div>

                    <!-- 좋아요한 글 탭 -->
                    <div class="tab-pane fade <%= "likes".equals(activeTab) ? "show active" : "" %>" id="likes">
                        <h5 class="mb-4"><i class="bi bi-heart text-danger"></i> 좋아요한 게시글</h5>

                        <% if (likedPosts.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="bi bi-heart"></i>
                            <h5>아직 좋아요한 게시글이 없습니다</h5>
                            <p>마음에 드는 게시글에 좋아요를 눌러보세요!</p>
                            <a href="${pageContext.request.contextPath}/community" class="btn btn-primary btn-browse">
                                <i class="bi bi-search"></i> 게시글 둘러보기
                            </a>
                        </div>
                        <% } else { %>
                        <% for (Community post : likedPosts) { %>
                        <div class="post-item">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <span class="badge badge-category bg-secondary me-2"><%= post.getCategoryDisplayName() %></span>
                                    <h6 class="mb-2">
                                        <a href="${pageContext.request.contextPath}/community?action=view&id=<%= post.getCommunityId() %>"
                                           class="text-decoration-none text-dark">
                                            <%= post.getTitle() %>
                                        </a>
                                    </h6>
                                    <small class="text-muted">
                                        <i class="bi bi-person"></i> <%= post.getAuthorNickname() %> |
                                        <i class="bi bi-clock"></i> <%= post.getFormattedCreatedAt() %> |
                                        <i class="bi bi-eye"></i> <%= post.getViewCount() %> |
                                        <i class="bi bi-heart"></i> <%= post.getLikeCount() %> |
                                        <i class="bi bi-chat"></i> <%= post.getCommentCount() %>
                                    </small>
                                </div>
                                <div class="ms-3">
                                    <a href="${pageContext.request.contextPath}/community?action=view&id=<%= post.getCommunityId() %>"
                                       class="btn btn-sm btn-outline-primary">보기</a>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        <% } %>
                    </div>

                    <!-- 내 댓글 탭 -->
                    <div class="tab-pane fade <%= "comments".equals(activeTab) ? "show active" : "" %>" id="comments">
                        <h5 class="mb-4"><i class="bi bi-chat text-success"></i> 내가 작성한 댓글</h5>

                        <% if (allComments.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="bi bi-chat-dots"></i>
                            <h5>아직 작성한 댓글이 없습니다</h5>
                            <p>게시글에 댓글을 남겨보세요!</p>
                            <a href="${pageContext.request.contextPath}/community" class="btn btn-primary btn-browse">
                                <i class="bi bi-search"></i> 게시글 둘러보기
                            </a>
                        </div>
                        <% } else { %>
                        <% for (Community comment : allComments) { %>
                        <div class="post-item">
                            <div class="mb-2">
                                <h6 class="mb-1">
                                    <a href="${pageContext.request.contextPath}/community?action=view&id=<%= comment.getCommunityId() %>"
                                       class="text-decoration-none text-dark">
                                        <i class="bi bi-arrow-return-right text-muted"></i> <%= comment.getTitle() %>
                                    </a>
                                </h6>
                                <div class="bg-light p-3 rounded">
                                    <p class="mb-1"><%= comment.getCommentContent() %></p>
                                </div>
                                <small class="text-muted">
                                    <i class="bi bi-clock"></i> <%= comment.getFormattedCommentCreatedAt() %> |
                                    <i class="bi bi-heart"></i> <%= comment.getCommentLikeCount() %>
                                </small>
                            </div>
                        </div>
                        <% } %>
                        <% } %>
                    </div>

                    <!-- 직관 일지 탭 -->
                    <div class="tab-pane fade <%= "games".equals(activeTab) ? "show active" : "" %>" id="games">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5><i class="bi bi-calendar-event text-warning"></i> 직관 일지</h5>
                            <button type="button" class="btn btn-primary" onclick="toggleRecordForm()">
                                <i class="bi bi-plus-circle"></i> 새 기록 추가
                            </button>
                        </div>

                        <!-- 직관 기록 추가 폼 (숨김 상태) -->
                        <div class="record-form" id="recordForm">
                            <h6 class="mb-3"><i class="bi bi-plus-circle"></i> 새 직관 기록 추가</h6>
                            <form action="${pageContext.request.contextPath}/mypage" method="post">
                                <input type="hidden" name="action" value="add_game_record">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">경기 날짜</label>
                                        <input type="date" class="form-control" name="gameDate" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">경기장</label>
                                        <select class="form-select" name="stadium" required>
                                            <option value="">경기장 선택</option>
                                            <option value="서울 잠실야구장">서울 잠실야구장</option>
                                            <option value="서울 고척스카이돔">서울 고척스카이돔</option>
                                            <option value="인천 SSG랜더스필드">인천 SSG랜더스필드</option>
                                            <option value="수원 KT위즈파크">수원 KT위즈파크</option>
                                            <option value="창원 NC파크">창원 NC파크</option>
                                            <option value="대구 삼성라이온즈파크">대구 삼성라이온즈파크</option>
                                            <option value="광주 기아챔피언스필드">광주 기아챔피언스필드</option>
                                            <option value="대전 한화생명볼파크">대전 한화생명볼파크</option>
                                            <option value="부산 사직야구장">부산 사직야구장</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">홈팀</label>
                                        <select class="form-select" name="homeTeam" required>
                                            <option value="">홈팀 선택</option>
                                            <option value="LG 트윈스">LG 트윈스</option>
                                            <option value="두산 베어스">두산 베어스</option>
                                            <option value="키움 히어로즈">키움 히어로즈</option>
                                            <option value="SSG 랜더스">SSG 랜더스</option>
                                            <option value="KT 위즈">KT 위즈</option>
                                            <option value="NC 다이노스">NC 다이노스</option>
                                            <option value="삼성 라이온즈">삼성 라이온즈</option>
                                            <option value="기아 타이거즈">기아 타이거즈</option>
                                            <option value="한화 이글스">한화 이글스</option>
                                            <option value="롯데 자이언츠">롯데 자이언츠</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">원정팀</label>
                                        <select class="form-select" name="awayTeam" required>
                                            <option value="">원정팀 선택</option>
                                            <option value="LG 트윈스">LG 트윈스</option>
                                            <option value="두산 베어스">두산 베어스</option>
                                            <option value="키움 히어로즈">키움 히어로즈</option>
                                            <option value="SSG 랜더스">SSG 랜더스</option>
                                            <option value="KT 위즈">KT 위즈</option>
                                            <option value="NC 다이노스">NC 다이노스</option>
                                            <option value="삼성 라이온즈">삼성 라이온즈</option>
                                            <option value="기아 타이거즈">기아 타이거즈</option>
                                            <option value="한화 이글스">한화 이글스</option>
                                            <option value="롯데 자이언츠">롯데 자이언츠</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">홈팀 점수</label>
                                        <input type="number" class="form-control" name="homeScore" min="0" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">원정팀 점수</label>
                                        <input type="number" class="form-control" name="awayScore" min="0" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">좌석</label>
                                        <input type="text" class="form-control" name="seat" placeholder="예: 1루 응원석">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">메모</label>
                                    <textarea class="form-control" name="memo" rows="3" placeholder="경기 후기나 특별한 순간을 기록해보세요!"></textarea>
                                </div>
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-plus"></i> 기록 추가
                                    </button>
                                    <button type="button" class="btn btn-secondary" onclick="toggleRecordForm()">
                                        <i class="bi bi-x"></i> 취소
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- 직관 기록 리스트 -->
                        <% if (recentGames.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="bi bi-calendar-event"></i>
                            <h5>아직 직관 기록이 없습니다</h5>
                            <p>첫 번째 직관 기록을 추가해보세요!</p>
                        </div>
                        <% } else { %>
                        <% for (GameRecord record : recentGames) { %>
                        <div class="record-item" id="record-<%= record.getRecordId() %>">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <div class="d-flex align-items-center mb-2">
                                        <span class="badge bg-primary me-2"><%= record.getStadium() %></span>
                                        <span class="text-muted"><%= record.getGameDate() %></span>
                                    </div>

                                    <div class="game-score">
                                        <%= record.getHomeTeam() %>
                                        <span class="text-primary"><%= record.getHomeScore() %></span> :
                                        <span class="text-danger"><%= record.getAwayScore() %></span>
                                        <%= record.getAwayTeam() %>
                                    </div>

                                    <div class="mb-2">
                                        <% if (record.isWin()) { %>
                                        <span class="winner-badge">
                                                        🏆 <%= record.getWinner() %> 승리
                                                    </span>
                                        <% } else { %>
                                        <span class="draw-badge">
                                                        ⚖️ 무승부
                                                    </span>
                                        <% } %>
                                    </div>

                                    <% if (record.getSeat() != null && !record.getSeat().isEmpty()) { %>
                                    <p class="mb-1"><i class="bi bi-geo-alt text-muted"></i> 좌석: <%= record.getSeat() %></p>
                                    <% } %>

                                    <% if (record.getMemo() != null && !record.getMemo().isEmpty()) { %>
                                    <p class="mb-1 text-muted"><i class="bi bi-chat-quote"></i> <%= record.getMemo() %></p>
                                    <% } %>

                                    <small class="text-muted">
                                        <i class="bi bi-clock"></i> 기록일: <%= record.getCreatedAt() %>
                                    </small>
                                </div>

                                <button class="btn btn-sm btn-outline-danger delete-record"
                                        data-record-id="<%= record.getRecordId() %>">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                        <% } %>

                        <% if (recentGames.size() >= 3) { %>
                        <div class="text-center mt-4">
                            <a href="?tab=games&all=true" class="btn btn-outline-primary">
                                모든 직관 기록 보기 <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                        <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 푸터 포함 -->
<jsp:include page="includes/footer.jsp">
    <jsp:param name="customJS" value="
        // 직관 기록 폼 토글
        function toggleRecordForm() {
            const form = document.getElementById('recordForm');
            if (form.style.display === 'none' || form.style.display === '') {
                form.style.display = 'block';
            } else {
                form.style.display = 'none';
            }
        }

        // 직관 기록 삭제
        document.querySelectorAll('.delete-record').forEach(button => {
            button.addEventListener('click', function() {
                const recordId = this.getAttribute('data-record-id');
                if (confirm('이 직관 기록을 삭제하시겠습니까?')) {
                    fetch('${pageContext.request.contextPath}/mypage', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `action=delete_game_record&recordId=${recordId}`
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            document.getElementById(`record-${recordId}`).remove();
                            alert('직관 기록이 삭제되었습니다.');
                            location.reload();
                        } else {
                            alert('삭제에 실패했습니다.');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('오류가 발생했습니다.');
                    });
                }
            });
        });

        // 성공 메시지 표시
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === 'added') {
            alert('직관 기록이 추가되었습니다! 🎉');
        }
    " />
</jsp:include>