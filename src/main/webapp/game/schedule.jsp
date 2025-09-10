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
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
  try {
    // 로그인 확인
    User user = (User)session.getAttribute("user");
    if (user == null) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    // 날짜 파라미터 처리
    String dateParam = request.getParameter("date");
    Date selectedDate = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    if (dateParam != null && !dateParam.isEmpty()) {
      try {
        selectedDate = sdf.parse(dateParam);
      } catch (Exception e) {
        // 파싱 오류 시 오늘 날짜 사용
        e.printStackTrace();
      }
    }

    // 이전/다음 날짜 계산
    Calendar cal = Calendar.getInstance();
    cal.setTime(selectedDate);

    cal.add(Calendar.DATE, -1);
    Date prevDate = cal.getTime();

    cal.add(Calendar.DATE, 2);
    Date nextDate = cal.getTime();

    // 선택한 날짜의 경기 가져오기
    GameDAO gameDAO = new GameDAO();
    List<Game> gamesOnDate = gameDAO.getGamesByDate(selectedDate);
    request.setAttribute("gamesOnDate", gamesOnDate);
    request.setAttribute("selectedDate", selectedDate);
    request.setAttribute("prevDate", prevDate);
    request.setAttribute("nextDate", nextDate);
    request.setAttribute("user", user);

    // 모든 팀 가져오기
    TeamDAO teamDAO = new TeamDAO();
    List<Team> allTeams = teamDAO.getAllTeams();
    request.setAttribute("allTeams", allTeams);

  } catch (Exception e) {
    e.printStackTrace();
    // 오류 페이지로 리다이렉트
    response.sendRedirect(request.getContextPath() + "/error.jsp");
    return;
  }
%>

<!-- 헤더 포함 -->
<jsp:include page="../includes/header.jsp">
  <jsp:param name="pageTitle" value="경기 일정" />
  <jsp:param name="activeMenu" value="game" />
  <jsp:param name="customCSS" value="
    <style>
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

      .team-logo-lg {
        width: 60px;
        height: 60px;
        object-fit: contain;
        filter: drop-shadow(0 3px 5px rgba(0, 0, 0, 0.1));
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

      /* 날짜 네비게이션 */
      .calendar-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
      }

      .calendar-title {
        font-size: 1.8rem;
        font-weight: 700;
        color: ${user.teamPrimaryColor != null ? user.teamPrimaryColor : '#1a3a7e'};
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

      /* 반응형 조정 */
      @media (max-width: 768px) {
        .calendar-header {
          flex-direction: column;
          gap: 10px;
        }

        .team-logo-lg {
          width: 50px;
          height: 50px;
        }
      }
    </style>
  " />
</jsp:include>

<!-- 메인 컨텐츠 -->
<div class="container mt-4">
  <h2 class="mb-4 animate-fade-in"><i class="bi bi-calendar3"></i> 경기 일정</h2>

  <!-- 뷰 모드 토글 버튼 -->
  <div class="text-center mb-4 animate-fade-in">
    <div class="btn-group" role="group">
      <a href="${pageContext.request.contextPath}/game/schedule.jsp" class="btn btn-primary">
        <i class="bi bi-list-ul"></i> 목록 보기
      </a>
      <a href="${pageContext.request.contextPath}/game/calendar.jsp" class="btn btn-outline-primary">
        <i class="bi bi-calendar3"></i> 달력 보기
      </a>
    </div>
  </div>

  <!-- 날짜 네비게이션 -->
  <div class="calendar-header animate-fade-in delay-1">
    <a href="${pageContext.request.contextPath}/game/schedule.jsp?date=<fmt:formatDate value="${prevDate}" pattern="yyyy-MM-dd" />" class="btn btn-outline-primary">
      <i class="bi bi-chevron-left"></i> 이전 날짜
    </a>
    <div class="calendar-title">
      <fmt:formatDate value="${selectedDate}" pattern="yyyy년 MM월 dd일 (E)" />
    </div>
    <a href="${pageContext.request.contextPath}/game/schedule.jsp?date=<fmt:formatDate value="${nextDate}" pattern="yyyy-MM-dd" />" class="btn btn-outline-primary">
      다음 날짜 <i class="bi bi-chevron-right"></i>
    </a>
  </div>

  <!-- 날짜 선택 폼 -->
  <div class="card mb-4 animate-fade-in delay-2" style="border: none; border-radius: 12px; box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1); overflow: hidden;">
    <div class="card-body">
      <form action="${pageContext.request.contextPath}/game/schedule.jsp" method="get" class="row g-3 align-items-center">
        <div class="col-md-8">
          <label for="date" class="form-label">날짜 선택</label>
          <input type="date" class="form-control" id="date" name="date" value="<fmt:formatDate value="${selectedDate}" pattern="yyyy-MM-dd" />">
        </div>
        <div class="col-md-4 d-flex align-items-end">
          <button type="submit" class="btn btn-primary">
            <i class="bi bi-search"></i> 검색
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- 경기 목록 -->
  <div class="row animate-fade-in delay-3">
    <c:choose>
      <c:when test="${not empty gamesOnDate}">
        <c:forEach var="game" items="${gamesOnDate}">
          <div class="col-md-6">
            <div class="game-card card">
              <div class="card-header d-flex justify-content-between align-items-center">
                <span>${game.gameTime}</span>
                <span>${game.stadium}</span>
                <c:choose>
                  <c:when test="${game.status == 'COMPLETED'}">
                    <span class="status-badge status-completed">경기 종료</span>
                  </c:when>
                  <c:when test="${game.status == 'SCHEDULED'}">
                    <span class="status-badge status-scheduled">예정</span>
                  </c:when>
                  <c:when test="${game.status == 'CANCELED'}">
                    <span class="status-badge status-canceled">취소</span>
                  </c:when>
                </c:choose>
              </div>
              <div class="card-body">
                <div class="row align-items-center text-center">
                  <div class="col-5">
                    <img src="${game.awayTeamLogo}" alt="${game.awayTeamName}" class="team-logo-lg mb-2">
                    <div class="team-name">${game.awayTeamName}</div>
                    <c:if test="${game.status == 'COMPLETED'}">
                      <div class="mt-2">
                        <span class="fw-bold fs-4">${game.awayScore}</span>
                      </div>
                      <div class="mt-1 small">
                        <span>투수: ${game.awayPitcher} (${game.awayPitcherResult})</span>
                      </div>
                    </c:if>
                  </div>
                  <div class="col-2">
                    <c:choose>
                      <c:when test="${game.status == 'COMPLETED'}">
                        <div class="game-vs">:</div>
                      </c:when>
                      <c:when test="${game.status == 'CANCELED'}">
                        <div class="game-vs text-danger">취소</div>
                      </c:when>
                      <c:otherwise>
                        <div class="game-vs">VS</div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="col-5">
                    <img src="${game.homeTeamLogo}" alt="${game.homeTeamName}" class="team-logo-lg mb-2">
                    <div class="team-name">${game.homeTeamName}</div>
                    <c:if test="${game.status == 'COMPLETED'}">
                      <div class="mt-2">
                        <span class="fw-bold fs-4">${game.homeScore}</span>
                      </div>
                      <div class="mt-1 small">
                        <span>투수: ${game.homePitcher} (${game.homePitcherResult})</span>
                      </div>
                    </c:if>
                  </div>
                </div>
                <c:if test="${game.status == 'COMPLETED'}">
                  <div class="text-center mt-3">
                    <span class="fw-bold">승리팀: ${game.winner}</span>
                  </div>
                </c:if>
              </div>
            </div>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <div class="col-12">
          <div class="alert alert-info text-center">
            <i class="bi bi-info-circle"></i> 선택한 날짜에 예정된 경기가 없습니다.
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- 푸터 포함 -->
<jsp:include page="../includes/footer.jsp">
  <jsp:param name="customJS" value="
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
  " />
</jsp:include>
