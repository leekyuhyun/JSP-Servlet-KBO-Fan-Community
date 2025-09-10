<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 사이드바 -->
<nav class="col-md-2 d-none d-md-block sidebar">
    <div class="sidebar-sticky pt-3 d-flex flex-column h-100">
        <div class="admin-title">
            <h4><i class="fas fa-baseball-ball me-2"></i>KBO Fan Admin</h4>
        </div>

        <ul class="nav flex-column flex-grow-1">
            <li class="nav-item">
                <a class="nav-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?action=dashboard">
                    <i class="fas fa-chart-line me-3"></i>대시보드
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.active == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?action=users">
                    <i class="fas fa-users me-3"></i>사용자 관리
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.active == 'posts' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?action=posts">
                    <i class="fas fa-file-text me-3"></i>게시글 관리
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.active == 'games' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?action=games">
                    <i class="fas fa-baseball-ball me-3"></i>경기 관리
                </a>
            </li>
        </ul>

        <!-- 사용자 정보 및 로그아웃 -->
        <div class="mt-auto">
            <div class="user-info">
                <div class="d-flex align-items-center mb-2">
                    <div class="rounded-circle bg-white bg-opacity-20 p-2 me-3">
                        <i class="fas fa-user-shield text-white"></i>
                    </div>
                    <div>
                        <div class="text-white-50 small">관리자</div>
                        <div class="text-white fw-semibold">${sessionScope.user.nickname}님</div>
                    </div>
                </div>
            </div>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout.jsp"
                       onclick="return confirm('로그아웃 하시겠습니까?')">
                        <i class="fas fa-sign-out-alt me-3"></i>로그아웃
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
