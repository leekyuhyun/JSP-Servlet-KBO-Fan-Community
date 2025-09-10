<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.kbofan.dao.TeamDAO" %>
<%@ page import="com.kbofan.dto.Team" %>

<%
    String teamIdParam = request.getParameter("id");
    if (teamIdParam == null || teamIdParam.isEmpty()) {
        response.sendRedirect("team_list.jsp");
        return;
    }

    int teamId = Integer.parseInt(teamIdParam);
    TeamDAO teamDAO = new TeamDAO();
    Team team = teamDAO.getTeamById(teamId);

    if (team == null) {
        response.sendRedirect("team_list.jsp");
        return;
    }

    request.setAttribute("team", team);
%>

<jsp:include page="/includes/header.jsp">
    <jsp:param name="pageTitle" value="${team.name} 상세 정보" />
    <jsp:param name="activeMenu" value="teams" />
</jsp:include>

<style>
    .team-logo-lg {
        width: 150px;
        height: 150px;
        object-fit: contain;
    }

    .team-header {
        background-color: ${team.primaryColor};
        color: white;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
    }

    .team-info {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
    }

    #map {
        width: 100%;
        height: 500px;
        border-radius: 10px;
        margin-top: 20px;
    }
</style>

<div class="container mt-4">
    <!-- 팀 헤더 -->
    <div class="team-header">
        <div class="row align-items-center">
            <div class="col-md-3 text-center">
                <img src="${team.logo}" class="team-logo-lg" alt="${team.name}">
            </div>
            <div class="col-md-9">
                <h1>${team.name}</h1>
                <p>
                    <i class="bi bi-geo-alt"></i> ${team.stadium_name}<br>
                    <i class="bi bi-trophy-fill"></i> ${team.championships}회 우승<br>
                    <i class="bi bi-calendar-check"></i> ${team.championshipYears}<br>
                    <i class="bi bi-globe"></i>
                    <a href="${team.officialSite}" target="_blank" class="text-white">${team.officialSite}</a>
                </p>
            </div>
        </div>
    </div>

    <!-- 팀 소개 -->
    <div class="team-info">
        <h4>구단 소개</h4>
        <p>${team.long_description}</p>
    </div>

    <!-- 지도 -->
    <div class="team-info">
        <h4>홈구장 위치</h4>
        <div id="map"></div>
    </div>

    <div class="mt-4">
        <a href="${pageContext.request.contextPath}/team/team_list.jsp" class="btn btn-secondary">
            <i class="bi bi-arrow-left"></i> 팀 목록으로 돌아가기
        </a>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=02d5915414cc4aa36016e7ebbb4798f8&autoload=false"></script>
<script>
    kakao.maps.load(function () {
        const lat = ${team.stadium_lat};
        const lng = ${team.stadium_lng};
        console.log("지도 좌표:", lat, lng);

        const container = document.getElementById('map');
        const options = {
            center: new kakao.maps.LatLng(lat, lng),
            level: 3
        };
        const map = new kakao.maps.Map(container, options);
        const marker = new kakao.maps.Marker({ position: map.getCenter() });
        marker.setMap(map);
    });
</script>

