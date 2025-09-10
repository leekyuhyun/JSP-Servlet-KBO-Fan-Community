<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.kbofan.dao.GameDAO" %>
<%@ page import="com.kbofan.dao.TeamDAO" %>
<%@ page import="com.kbofan.dto.Game" %>
<%@ page import="com.kbofan.dto.Team" %>
<%@ page import="com.kbofan.dto.User" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 로그인 확인
    User user = (User)session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // 현재 년월 파라미터 처리
    String yearParam = request.getParameter("year");
    String monthParam = request.getParameter("month");

    Calendar cal = Calendar.getInstance();
    int year = cal.get(Calendar.YEAR);
    int month = cal.get(Calendar.MONTH) + 1; // 0-based to 1-based

    if (yearParam != null && !yearParam.isEmpty()) {
        try {
            year = Integer.parseInt(yearParam);
        } catch (NumberFormatException e) {
            // 기본값 사용
        }
    }

    if (monthParam != null && !monthParam.isEmpty()) {
        try {
            month = Integer.parseInt(monthParam);
            if (month < 1) {
                month = 12;
                year--;
            } else if (month > 12) {
                month = 1;
                year++;
            }
        } catch (NumberFormatException e) {
            // 기본값 사용
        }
    }

    // 이전/다음 월 계산
    int prevMonth = month - 1;
    int prevYear = year;
    if (prevMonth < 1) {
        prevMonth = 12;
        prevYear--;
    }

    int nextMonth = month + 1;
    int nextYear = year;
    if (nextMonth > 12) {
        nextMonth = 1;
        nextYear++;
    }

    // 달력 생성을 위한 날짜 계산
    cal.set(year, month - 1, 1); // 해당 월의 1일로 설정
    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // 1일의 요일 (1: 일요일, 7: 토요일)
    int lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH); // 해당 월의 마지막 날짜

    // 해당 월의 모든 경기 가져오기
    GameDAO gameDAO = new GameDAO();
    Map<Integer, List<Game>> gamesByDay = new HashMap<>();

    // 해당 월의 시작일과 종료일 설정
    Calendar startCal = Calendar.getInstance();
    startCal.set(year, month - 1, 1, 0, 0, 0);
    startCal.set(Calendar.MILLISECOND, 0);

    Calendar endCal = Calendar.getInstance();
    endCal.set(year, month - 1, lastDay, 23, 59, 59);
    endCal.set(Calendar.MILLISECOND, 999);

    // 해당 월의 모든 경기 조회
    List<Game> monthGames = gameDAO.getGamesByDateRange(startCal.getTime(), endCal.getTime());

    // 날짜별로 경기 분류
    for (Game game : monthGames) {
        Calendar gameCal = Calendar.getInstance();
        gameCal.setTime(game.getGameDate());
        int day = gameCal.get(Calendar.DAY_OF_MONTH);

        if (!gamesByDay.containsKey(day)) {
            gamesByDay.put(day, new ArrayList<>());
        }
        gamesByDay.get(day).add(game);
    }

    // 모든 팀 가져오기
    TeamDAO teamDAO = new TeamDAO();
    List<Team> allTeams = teamDAO.getAllTeams();
    request.setAttribute("allTeams", allTeams);

    // 월 이름 배열
    String[] monthNames = {"", "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"};

    // 팀 필터 처리
    String teamFilter = request.getParameter("team");

    // 상태 필터 처리
    String statusFilter = request.getParameter("status");
%>

<!-- 헤더 포함 -->
<jsp:include page="../includes/header.jsp">
    <jsp:param name="pageTitle" value="달력 보기" />
    <jsp:param name="activeMenu" value="game" />
    <jsp:param name="customCSS" value="
    <style>
      /* 캘린더 스타일 */
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

      .calendar-nav {
        display: flex;
        gap: 10px;
      }

      .calendar-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        background-color: white;
      }

      .calendar-table th {
        background-color: ${user.teamPrimaryColor != null ? user.teamPrimaryColor : '#1a3a7e'};
        color: white;
        text-align: center;
        padding: 12px;
        font-weight: 500;
      }

      .calendar-table td {
        height: 120px;
        width: 14.28%;
        vertical-align: top;
        border: 1px solid #dee2e6;
        padding: 8px;
        transition: all 0.3s ease;
      }

      .calendar-table td:hover {
        background-color: rgba(0, 0, 0, 0.02);
      }

      .calendar-day {
        font-weight: 700;
        margin-bottom: 8px;
        text-align: right;
      }

      .calendar-day.today {
        background-color: ${user.teamPrimaryColor != null ? user.teamPrimaryColor : '#1a3a7e'};
        color: white;
        border-radius: 50%;
        width: 28px;
        height: 28px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        float: right;
      }

      .calendar-day.sunday {
        color: #dc3545;
      }

      .calendar-day.saturday {
        color: #0d6efd;
      }

      .calendar-events {
        overflow-y: auto;
        max-height: 100px;
      }

      .calendar-event {
        font-size: 0.8rem;
        margin-bottom: 5px;
        padding: 4px 8px;
        border-radius: 5px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        display: flex;
        align-items: center;
        transition: all 0.3s ease;
        text-decoration: none;
      }

      .calendar-event:hover {
        transform: translateY(-2px);
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      }

      .calendar-event.completed {
        background-color: #d1e7dd;
        color: #0f5132;
      }

      .calendar-event.scheduled {
        background-color: #cfe2ff;
        color: #084298;
      }

      .calendar-event.canceled {
        background-color: #f8d7da;
        color: #842029;
        text-decoration: line-through;
      }

      .calendar-event img {
        width: 16px;
        height: 16px;
        margin-right: 5px;
      }

      .calendar-event-time {
        font-weight: 700;
        margin-right: 5px;
      }

      .other-month {
        background-color: #f8f9fa;
        color: #adb5bd;
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

      /* 반응형 조정 */
      @media (max-width: 768px) {
        .calendar-header {
          flex-direction: column;
          gap: 10px;
        }

        .calendar-nav {
          width: 100%;
          justify-content: space-between;
        }

        .calendar-table td {
          height: 100px;
          padding: 5px;
        }

        .calendar-event {
          font-size: 0.7rem;
          padding: 2px 4px;
        }
      }
    </style>
  " />
</jsp:include>

<!-- 메인 컨텐츠 -->
<div class="container mt-4">
    <div class="calendar-header animate-fade-in">
        <div class="calendar-title">
            <i class="bi bi-calendar3"></i> <%= year %>년 <%= monthNames[month] %> 경기 일정
        </div>
        <div class="calendar-nav">
            <a href="${pageContext.request.contextPath}/game/calendar.jsp?year=<%= prevYear %>&month=<%= prevMonth %>" class="btn btn-outline-primary">
                <i class="bi bi-chevron-left"></i> 이전 달
            </a>
            <a href="${pageContext.request.contextPath}/game/calendar.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-calendar-check"></i> 이번 달
            </a>
            <a href="${pageContext.request.contextPath}/game/calendar.jsp?year=<%= nextYear %>&month=<%= nextMonth %>" class="btn btn-outline-primary">
                다음 달 <i class="bi bi-chevron-right"></i>
            </a>
        </div>
    </div>

    <!-- 필터 섹션 -->
    <div class="mb-4 animate-fade-in delay-1">
        <div class="card" style="border: none; border-radius: 12px; box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1); overflow: hidden;">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/game/calendar.jsp" method="get" class="row g-3 align-items-center">
                    <input type="hidden" name="year" value="<%= year %>">
                    <input type="hidden" name="month" value="<%= month %>">

                    <div class="col-md-4">
                        <label for="teamFilter" class="form-label">팀 필터</label>
                        <select class="form-select" id="teamFilter" name="team">
                            <option value="">모든 팀</option>
                            <c:forEach var="team" items="${allTeams}">
                                <option value="${team.teamId}" ${param.team == team.teamId ? 'selected' : ''}>${team.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="statusFilter" class="form-label">상태 필터</label>
                        <select class="form-select" id="statusFilter" name="status">
                            <option value="">모든 상태</option>
                            <option value="SCHEDULED" ${param.status == 'SCHEDULED' ? 'selected' : ''}>예정</option>
                            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>종료</option>
                            <option value="CANCELED" ${param.status == 'CANCELED' ? 'selected' : ''}>취소</option>
                        </select>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i> 필터 적용
                        </button>
                        <a href="${pageContext.request.contextPath}/game/schedule.jsp" class="btn btn-outline-primary ms-2">
                            <i class="bi bi-list"></i> 목록 보기
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 달력 -->
    <div class="table-responsive animate-fade-in delay-2">
        <table class="calendar-table">
            <thead>
            <tr>
                <th>일</th>
                <th>월</th>
                <th>화</th>
                <th>수</th>
                <th>목</th>
                <th>금</th>
                <th>토</th>
            </tr>
            </thead>
            <tbody>
            <%
                // 현재 날짜 정보
                Calendar today = Calendar.getInstance();
                int currentYear = today.get(Calendar.YEAR);
                int currentMonth = today.get(Calendar.MONTH) + 1;
                int currentDay = today.get(Calendar.DAY_OF_MONTH);

                // 달력 그리기
                int dayCount = 1;
                boolean started = false;

                // 최대 6주 표시
                for (int week = 0; week < 6; week++) {
                    out.println("<tr>");

                    // 각 요일 (0: 일요일, 6: 토요일)
                    for (int dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++) {
                        // 첫 주에서 시작일 이전은 빈 칸
                        if (week == 0 && dayOfWeek + 1 < firstDayOfWeek) {
                            out.println("<td class='other-month'></td>");
                            continue;
                        }

                        // 마지막 날 이후는 빈 칸
                        if (dayCount > lastDay) {
                            out.println("<td class='other-month'></td>");
                            continue;
                        }

                        // 오늘 날짜 강조
                        boolean isToday = (year == currentYear && month == currentMonth && dayCount == currentDay);

                        // 요일별 스타일 (일요일, 토요일)
                        String dayClass = "";
                        if (dayOfWeek == 0) dayClass = "sunday";
                        if (dayOfWeek == 6) dayClass = "saturday";

                        out.println("<td>");

                        // 날짜 표시
                        if (isToday) {
                            out.println("<div class='calendar-day today'>" + dayCount + "</div>");
                        } else {
                            out.println("<div class='calendar-day " + dayClass + "'>" + dayCount + "</div>");
                        }

                        // 해당 날짜의 경기 표시
                        List<Game> dayGames = gamesByDay.get(dayCount);
                        if (dayGames != null && !dayGames.isEmpty()) {
                            out.println("<div class='calendar-events'>");
                            for (Game game : dayGames) {
                                // 필터 적용
                                if (teamFilter != null && !teamFilter.isEmpty()) {
                                    int teamId = Integer.parseInt(teamFilter);
                                    if (game.getAwayTeam() != teamId && game.getHomeTeam() != teamId) {
                                        continue;
                                    }
                                }

                                if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals(game.getStatus())) {
                                    continue;
                                }

                                String eventClass = "";
                                if ("COMPLETED".equals(game.getStatus())) {
                                    eventClass = "completed";
                                } else if ("SCHEDULED".equals(game.getStatus())) {
                                    eventClass = "scheduled";
                                } else if ("CANCELED".equals(game.getStatus())) {
                                    eventClass = "canceled";
                                }

                                out.println("<a href='" + request.getContextPath() + "/game/detail.jsp?id=" + game.getGameId() + "' class='calendar-event " + eventClass + "'>");
                                out.println("<span class='calendar-event-time'>" + game.getGameTime() + "</span>");
                                out.println("<img src='" + game.getAwayTeamLogo() + "' alt='" + game.getAwayTeamName() + "'>");
                                out.println("vs");
                                out.println("<img src='" + game.getHomeTeamLogo() + "' alt='" + game.getHomeTeamName() + "'>");
                                out.println("</a>");
                            }
                            out.println("</div>");
                        }

                        out.println("</td>");

                        dayCount++;
                    }

                    out.println("</tr>");

                    // 마지막 날짜를 표시했으면 종료
                    if (dayCount > lastDay) {
                        break;
                    }
                }
            %>
            </tbody>
        </table>
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