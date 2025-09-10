<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.kbofan.dao.GameDAO" %>
<%@ page import="com.kbofan.dao.TeamDAO" %>
<%@ page import="com.kbofan.dto.Game" %>
<%@ page import="com.kbofan.dto.Team" %>
<%@ page import="com.kbofan.dto.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%
    // 로그인 확인은 header.jsp에서 처리하므로 여기서는 제거

    // 최근 경기 결과 가져오기
    GameDAO gameDAO = new GameDAO();
    List<Game> recentGames = gameDAO.getRecentGames(5);
    request.setAttribute("recentGames", recentGames);

    // 예정된 경기 가져오기
    List<Game> upcomingGames = gameDAO.getUpcomingGames(5);
    request.setAttribute("upcomingGames", upcomingGames);

    // 팀 순위 가져오기 - Game 테이블 데이터 기반으로 계산
    TeamDAO teamDAO = new TeamDAO();
    List<Team> teamRankings = teamDAO.getTeamRankings();
    request.setAttribute("teamRankings", teamRankings);
    List<Team> teamList = teamDAO.getAllTeams();
    request.setAttribute("teamList", teamList);

    // 오늘 날짜
    request.setAttribute("today", new Date());
%>

<jsp:include page="/includes/header.jsp">
    <jsp:param name="pageTitle" value="메인" />
    <jsp:param name="activeMenu" value="home" />
    <jsp:param name="customCSS" value="
        <style>
            /* 섹션 헤더 */
            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
                border-bottom: 3px solid ${user.teamPrimaryColor};
                padding-bottom: 0.8rem;
                position: relative;
            }

            .section-title {
                font-size: 1.5rem;
                font-weight: 700;
                margin: 0;
                display: flex;
                align-items: center;
                color: ${user.teamPrimaryColor};
            }

            .section-title i {
                margin-right: 0.5rem;
                font-size: 1.3rem;
            }

            .section-link {
                font-size: 0.9rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .section-link:hover {
                transform: translateX(3px);
            }

            /* 팀 로고 */
            .team-logo {
                width: 24px;
                height: 24px;
                object-fit: contain;
                filter: drop-shadow(0 2px 3px rgba(0, 0, 0, 0.1));
                transition: all 0.3s ease;
                vertical-align: middle;
            }

            .team-logo:hover {
                transform: scale(1.1);
            }

            /* 순위 테이블 */
            .standings-card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                transition: all 0.3s ease;
                margin-bottom: 20px;
                max-width: 100%;
                background-color: white;
            }

            .standings-card:hover {
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
            }

            .standings-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 0.85rem;
                margin-bottom: 0;
                table-layout: fixed;
                color: #333333;
            }

            .standings-table th,
            .standings-table td {
                padding: 8px 3px;
                text-align: center;
                vertical-align: middle;
                white-space: nowrap;
            }

            .standings-table th {
                background-color: #f0f0f0;
                font-weight: 600;
                color: #333333;
                position: sticky;
                top: 0;
                z-index: 10;
                border-bottom: 2px solid #dddddd;
            }

            .standings-table td {
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                color: #333333;
            }

            .standings-table tr:hover {
                background-color: rgba(0, 0, 0, 0.02);
            }

            /* 테이블 열 너비 설정 */
            .standings-table th:nth-child(1),
            .standings-table td:nth-child(1) {
                width: 40px;
            }

            .standings-table th:nth-child(2),
            .standings-table td:nth-child(2) {
                width: 110px;
                text-align: left;
            }

            .standings-table th:nth-child(3),
            .standings-table td:nth-child(3),
            .standings-table th:nth-child(4),
            .standings-table td:nth-child(4),
            .standings-table th:nth-child(5),
            .standings-table td:nth-child(5),
            .standings-table th:nth-child(6),
            .standings-table td:nth-child(6) {
                width: 30px;
            }

            .standings-table th:nth-child(7),
            .standings-table td:nth-child(7) {
                width: 50px;
            }

            .standings-table th:nth-child(8),
            .standings-table td:nth-child(8) {
                width: 50px;
            }

            .standings-table .team-cell {
                display: flex;
                align-items: center;
                text-align: left;
                padding-left: 5px;
                font-weight: 500;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .standings-table .team-cell img {
                margin-right: 5px;
                flex-shrink: 0;
            }

            .standings-table .rank-cell {
                font-weight: 700;
                font-size: 1rem;
                color: ${user.teamPrimaryColor};
            }

            .standings-table .games-behind {
                color: #6c757d;
                font-weight: 500;
            }

            /* 경기 카드 */
            .game-card {
                border: none;
                border-radius: 12px;
                overflow: hidden;
                margin-bottom: 20px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                background-color: white;
            }

            .game-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
            }

            .game-card .card-header {
                background: linear-gradient(to right, rgba(0,0,0,0.05), rgba(0,0,0,0));
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                padding: 12px 15px;
                font-weight: 500;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .game-teams {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                background-color: white;
            }

            .game-team {
                display: flex;
                flex-direction: column;
                align-items: center;
                width: 45%;
                transition: all 0.3s ease;
            }

            .game-team:hover {
                transform: scale(1.05);
            }

            .game-team img {
                width: 60px;
                height: 60px;
                margin-bottom: 10px;
                filter: drop-shadow(0 3px 5px rgba(0, 0, 0, 0.1));
            }

            .game-vs {
                font-size: 1.5rem;
                font-weight: 700;
                color: #6c757d;
                position: relative;
                width: 50px;
                height: 50px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .game-vs::before {
                content: '';
                position: absolute;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: rgba(0, 0, 0, 0.03);
                z-index: -1;
            }

            .game-info {
                background-color: #f8f9fa;
                padding: 12px;
                text-align: center;
                border-top: 1px solid rgba(0, 0, 0, 0.05);
                font-weight: 500;
                color: #555;
            }

            .game-pitcher {
                font-size: 0.85rem;
                color: #6c757d;
                margin-top: 5px;
                font-style: italic;
            }

            /* 상태 배지 */
            .status-badge {
                font-size: 0.8rem;
                padding: 4px 10px;
                border-radius: 20px;
                font-weight: 600;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .status-completed {
                background-color: #28a745;
                color: white;
            }

            .status-scheduled {
                background-color: #007bff;
                color: white;
            }

            .status-canceled {
                background-color: #dc3545;
                color: white;
            }

            /* 최근 경기 결과 테이블 */
            .results-table {
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
                background-color: white;
            }

            .results-table .table {
                margin-bottom: 0;
                color: #333333;
            }

            .results-table thead th {
                background-color: #f0f0f0;
                color: #333333;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.5px;
                border-bottom: 2px solid #dddddd;
            }

            .results-table .table-striped tbody tr:nth-of-type(odd) {
                background-color: rgba(0, 0, 0, 0.02);
            }

            .results-table td {
                vertical-align: middle;
                padding: 12px 15px;
                color: #333333;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            }

            .score-cell {
                font-weight: 700;
                font-size: 1.1rem;
                text-align: center;
                color: ${user.teamPrimaryColor};
            }

            /* 반응형 조정 */
            @media (max-width: 768px) {
                .section-header {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .section-link {
                    margin-top: 0.5rem;
                }

                .game-team img {
                    width: 50px;
                    height: 50px;
                }
            }

            /* 애니메이션 효과 */
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .animate-fade-in {
                animation: fadeIn 0.5s ease-out forwards;
            }

            .delay-1 { animation-delay: 0.1s; }
            .delay-2 { animation-delay: 0.2s; }
            .delay-3 { animation-delay: 0.3s; }
            .delay-4 { animation-delay: 0.4s; }
        </style>
    " />
</jsp:include>

<div class="container mt-4">
    <!-- 환영 메시지 -->
    <div class="row mb-4 animate-fade-in">
        <div class="col-12">
            <div class="card" style="border: none; border-radius: 12px; box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1); overflow: hidden;">
                <div class="card-body" style="background: linear-gradient(135deg, ${user.teamPrimaryColor}, ${user.teamSecondaryColor}); color: white;">
                    <h5 class="card-title">안녕하세요, ${user.nickname}님!</h5>
                    <p class="card-text">KBO Fan 커뮤니티에 오신 것을 환영합니다. 최신 경기 결과와 팀 정보를 확인하세요.</p>
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/game/schedule.jsp" class="btn btn-light">경기 일정 보기</a>
                        <a href="${pageContext.request.contextPath}/team/team_list.jsp" class="btn btn-outline-light ms-2">팀 정보 보기</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- 왼쪽 컬럼: 팀 순위 -->
        <div class="col-md-4 mb-4 animate-fade-in delay-1">
            <div class="section-header">
                <h4 class="section-title"><i class="bi bi-trophy"></i> KBO리그 순위</h4>
                <a href="${pageContext.request.contextPath}/team/detail.jsp" class="section-link btn btn-sm btn-outline-primary">
                    <i class="bi bi-arrow-right"></i> 팀 정보 보기
                </a>
            </div>
            <div class="standings-card card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="standings-table">
                            <thead>
                            <tr>
                                <th>순위</th>
                                <th style="text-align: left;">팀명</th>
                                <th>경기</th>
                                <th>승</th>
                                <th>무</th>
                                <th>패</th>
                                <th>승률</th>
                                <th>게임차</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="team" items="${teamRankings}">
                                <tr>
                                    <td class="rank-cell">${team.rank}</td>
                                    <td class="team-cell">
                                        <img src="${team.logo}" alt="${team.name}" class="team-logo">
                                            ${team.name}
                                    </td>
                                    <td>${team.wins + team.losses + team.draws}</td>
                                    <td>${team.wins}</td>
                                    <td>${team.draws}</td>
                                    <td>${team.losses}</td>
                                    <td><fmt:formatNumber value="${team.winningPercentage}" pattern=".000" minFractionDigits="3" maxFractionDigits="3" /></td>
                                    <td class="games-behind">
                                        <fmt:formatNumber value="${team.gamesBehind}" pattern="0.0" />
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- 오른쪽 컬럼: 예정된 경기 및 최근 경기 결과 -->
        <div class="col-md-8">
            <!-- 예정된 경기 -->
            <div class="section-header animate-fade-in delay-2">
                <h4 class="section-title"><i class="bi bi-calendar"></i> 예정된 경기</h4>
                <a href="${pageContext.request.contextPath}/game/schedule.jsp" class="section-link btn btn-sm btn-outline-primary">
                    <i class="bi bi-calendar3"></i> 전체 일정 보기
                </a>
            </div>
            <div class="row animate-fade-in delay-2">
                <c:forEach var="game" items="${upcomingGames}">
                    <div class="col-md-6">
                        <div class="game-card card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <span><fmt:formatDate value="${game.gameDate}" pattern="yyyy.MM.dd (E)" /></span>
                                <span>${game.gameTime}</span>
                                <c:choose>
                                    <c:when test="${game.status == 'SCHEDULED'}">
                                        <span class="status-badge status-scheduled">예정</span>
                                    </c:when>
                                    <c:when test="${game.status == 'CANCELED'}">
                                        <span class="status-badge status-canceled">취소</span>
                                    </c:when>
                                </c:choose>
                            </div>
                            <div class="game-teams">
                                <div class="game-team">
                                    <img src="${game.awayTeamLogo}" alt="${game.awayTeamName}">
                                    <div class="fw-bold">${game.awayTeamName}</div>
                                    <c:if test="${not empty game.awayPitcher}">
                                        <div class="game-pitcher">예정 선발: ${game.awayPitcher}</div>
                                    </c:if>
                                </div>
                                <div class="game-vs">
                                    <c:choose>
                                        <c:when test="${game.status == 'CANCELED'}">취소</c:when>
                                        <c:otherwise>VS</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="game-team">
                                    <img src="${game.homeTeamLogo}" alt="${game.homeTeamName}">
                                    <div class="fw-bold">${game.homeTeamName}</div>
                                    <c:if test="${not empty game.homePitcher}">
                                        <div class="game-pitcher">예정 선발: ${game.homePitcher}</div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="game-info">
                                <i class="bi bi-geo-alt"></i> ${game.stadium}
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty upcomingGames}">
                    <div class="col-12">
                        <div class="alert alert-info text-center">
                            <i class="bi bi-info-circle"></i> 예정된 경기가 없습니다.
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- 최근 경기 결과 -->
            <div class="section-header mt-4 animate-fade-in delay-3">
                <h4 class="section-title"><i class="bi bi-calendar-check"></i> 최근 경기 결과</h4>
                <a href="${pageContext.request.contextPath}/game/schedule.jsp?view=results" class="section-link btn btn-sm btn-outline-primary">
                    <i class="bi bi-list-check"></i> 전체 결과 보기
                </a>
            </div>

            <div class="results-table animate-fade-in delay-3">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>날짜</th>
                            <th>원정팀</th>
                            <th>점수</th>
                            <th>홈팀</th>
                            <th>승리팀</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="game" items="${recentGames}" varStatus="status">
                            <tr class="${status.index % 2 == 0 ? 'table-light' : ''}">
                                <td><fmt:formatDate value="${game.gameDate}" pattern="MM.dd (E)" /></td>
                                <td>
                                    <img src="${game.awayTeamLogo}" alt="${game.awayTeamName}" class="team-logo">
                                        ${game.awayTeamName}
                                </td>
                                <td class="score-cell">
                                        ${game.awayScore} - ${game.homeScore}
                                </td>
                                <td>
                                    <img src="${game.homeTeamLogo}" alt="${game.homeTeamName}" class="team-logo">
                                        ${game.homeTeamName}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${game.awayScore == game.homeScore}">무승부</c:when>
                                        <c:otherwise>${game.winner}</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentGames}">
                            <tr>
                                <td colspan="5" class="text-center">최근 경기 결과가 없습니다.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp">
    <jsp:param name="customJS" value="
        <script>
            // 페이지 로드 시 애니메이션 효과
            document.addEventListener('DOMContentLoaded', function() {
                const animatedElements = document.querySelectorAll('.animate-fade-in');
                animatedElements.forEach(element => {
                    element.style.opacity = '0';
                });

                setTimeout(() => {
                    animatedElements.forEach(element => {
                        element.style.opacity = '1';
                    });
                }, 100);
            });
        </script>
    " />
</jsp:include>