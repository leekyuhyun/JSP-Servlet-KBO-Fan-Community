<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 푸터 -->
<footer class="bg-dark text-light py-4 mt-5">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h5>KBO Fan</h5>
                <p>한국 프로야구 팬 커뮤니티</p>
                <div class="d-flex mt-3">
                    <a href="#" class="text-light me-3"><i class="bi bi-facebook fs-4"></i></a>
                    <a href="#" class="text-light me-3"><i class="bi bi-twitter fs-4"></i></a>
                    <a href="#" class="text-light me-3"><i class="bi bi-instagram fs-4"></i></a>
                    <a href="#" class="text-light"><i class="bi bi-youtube fs-4"></i></a>
                </div>
            </div>
            <div class="col-md-4">
                <h5>바로가기</h5>
                <ul class="list-styled">
                    <li><a href="${pageContext.request.contextPath}/main.jsp" class="text-light text-decoration-none">홈</a></li>
                    <li><a href="${pageContext.request.contextPath}/team/team_list.jsp" class="text-light text-decoration-none">팀 정보</a></li>
                    <li><a href="${pageContext.request.contextPath}/game/schedule.jsp" class="text-light text-decoration-none">경기 일정</a></li>
                    <li><a href="${pageContext.request.contextPath}/community/list" class="text-light text-decoration-none">커뮤니티</a></li>
                    <li><a href="${pageContext.request.contextPath}/ticket.jsp" class="text-light text-decoration-none">좌석 확인</a></li>
                    <li><a href="${pageContext.request.contextPath}/mypage.jsp" class="text-light text-decoration-none">마이 페이지</a></li>
                </ul>
            </div>
            <div class="col-md-4 text-md-end">
                <h5>연락처</h5>
                <p>이메일: leekh010502@naver.com</p>
                <p>전화: 010-8529-5540</p>
                <p>도움: 자리어때</p>
                <p>&copy; 2025 KBO Fan. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
    ${param.customJS}
</script>