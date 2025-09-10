<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.kbofan.dao.TeamDAO" %>
<%@ page import="com.kbofan.dto.Team" %>
<%@ page import="java.util.List" %>
<%
    TeamDAO teamDAO = new TeamDAO();
    List<Team> teams = teamDAO.getAllTeams();
    request.setAttribute("teams", teams);
%>

<jsp:include page="/includes/header.jsp">
    <jsp:param name="pageTitle" value="팀 정보" />
    <jsp:param name="activeMenu" value="teams" />
</jsp:include>

<div class="container mt-5">
    <h2 class="mb-4 fw-bold text-primary"><i class="bi bi-people-fill"></i> 구단별 팀 정보</h2>
    <div class="row">
        <c:forEach var="team" items="${teams}">
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card h-100 shadow-sm border-0" style="border-left: 6px solid ${team.primaryColor};">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <img src="${team.logo}" alt="${team.name}" class="me-3" style="width: 50px; height: 50px; object-fit: contain;">
                            <div>
                                <h5 class="card-title mb-0">${team.name}</h5>
                                <small class="text-muted">홈구장: ${team.stadium_name}</small>
                            </div>
                        </div>
                        <p class="card-text small text-muted">
                            <c:out value="${team.description}" default="설명 없음" />
                        </p>
                    </div>
                    <div class="card-footer bg-light d-flex justify-content-between">
                        <a href="${team.officialSite}" class="btn btn-sm btn-outline-primary" target="_blank">
                            공식 사이트 <i class="bi bi-box-arrow-up-right"></i>
                        </a>
                        <div>
                            <a href="${pageContext.request.contextPath}/team/detail.jsp?id=${team.teamId}" class="btn btn-sm btn-info text-white me-1">
                                상세보기
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
