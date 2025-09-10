<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="${game != null ? '경기 수정' : '경기 추가'}" />
</jsp:include>

<!-- 사이드바 포함 -->
<jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="games" />
</jsp:include>

<!-- 메인 컨텐츠 -->
<main class="col-md-10 ml-sm-auto main-content">
    <!-- 페이지 헤더 -->
    <div class="page-header fade-in-up">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h2 mb-2">${game != null ? '경기 수정' : '경기 추가'}</h1>
                <p class="mb-0">경기 정보 ${game != null ? '수정' : '등록'}</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin?action=games" class="btn btn-secondary btn-custom">
                    <i class="fas fa-arrow-left me-2"></i>목록으로
                </a>
            </div>
        </div>
    </div>

    <!-- 경기 폼 -->
    <div class="card fade-in-up" style="animation-delay: 0.2s">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin">
                <input type="hidden" name="action" value="${game != null ? 'updateGame' : 'addGame'}">
                <c:if test="${game != null}">
                    <input type="hidden" name="gameId" value="${game.gameId}">
                </c:if>

                <div class="row">
                    <!-- 기본 정보 -->
                    <div class="col-md-6">
                        <div class="card border-0 bg-light bg-opacity-50 mb-4">
                            <div class="card-body">
                                <h5 class="mb-4 fw-bold text-primary">
                                    <i class="fas fa-info-circle me-2"></i>기본 정보
                                </h5>

                                <div class="mb-3">
                                    <label for="gameDate" class="form-label fw-semibold">
                                        <i class="fas fa-calendar me-2 text-primary"></i>경기 날짜 *
                                    </label>
                                    <input type="date" class="form-control" id="gameDate" name="gameDate"
                                           value="<fmt:formatDate value='${game.gameDate}' pattern='yyyy-MM-dd'/>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="gameTime" class="form-label fw-semibold">
                                        <i class="fas fa-clock me-2 text-primary"></i>경기 시간 *
                                    </label>
                                    <input type="time" class="form-control" id="gameTime" name="gameTime"
                                           value="${game.gameTime}" required>
                                </div>

                                <div class="mb-3">
                                    <label for="stadium" class="form-label fw-semibold">
                                        <i class="fas fa-map-marker-alt me-2 text-primary"></i>구장 *
                                    </label>
                                    <select class="form-select" id="stadium" name="stadium" required>
                                        <option value="">구장을 선택하세요</option>
                                        <option value="서울 잠실야구장" ${game.stadium == '서울 잠실야구장' ? 'selected' : ''}>서울 잠실야구장 (LG, 두산)</option>
                                        <option value="서울 고척스카이돔" ${game.stadium == '서울 고척스카이돔' ? 'selected' : ''}>서울 고척스카이돔 (키움)</option>
                                        <option value="인천 SSG랜더스필드" ${game.stadium == '인천 SSG랜더스필드' ? 'selected' : ''}>인천 SSG랜더스필드 (SSG)</option>
                                        <option value="수원 KT위즈파크" ${game.stadium == '수원 KT위즈파크' ? 'selected' : ''}>수원 KT위즈파크 (KT)</option>
                                        <option value="대전 한화생명볼파크" ${game.stadium == '대전 한화생명볼파크' ? 'selected' : ''}>대전 한화생명볼파크 (한화)</option>
                                        <option value="대구 삼성라이온즈파크" ${game.stadium == '대구 삼성라이온즈파크' ? 'selected' : ''}>대구 삼성라이온즈파크 (삼성)</option>
                                        <option value="부산 사직야구장" ${game.stadium == '부산 사직야구장' ? 'selected' : ''}>부산 사직야구장 (롯데)</option>
                                        <option value="울산 문수야구장" ${game.stadium == '울산 문수야구장' ? 'selected' : ''}>울산 문수야구장</option>
                                        <option value="창원 NC파크" ${game.stadium == '창원 NC파크' ? 'selected' : ''}>창원 NC파크 (NC)</option>
                                        <option value="광주 KIA챔피언스필드" ${game.stadium == '광주 KIA챔피언스필드' ? 'selected' : ''}>광주 KIA챔피언스필드 (KIA)</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="awayTeam" class="form-label fw-semibold">
                                        <i class="fas fa-plane me-2 text-warning"></i>원정팀 *
                                    </label>
                                    <select class="form-select" id="awayTeam" name="awayTeam" required>
                                        <option value="">팀을 선택하세요</option>
                                        <c:forEach var="team" items="${teams}">
                                            <option value="${team.teamId}" ${game.awayTeam == team.teamId ? 'selected' : ''}>
                                                    ${team.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="homeTeam" class="form-label fw-semibold">
                                        <i class="fas fa-home me-2 text-success"></i>홈팀 *
                                    </label>
                                    <select class="form-select" id="homeTeam" name="homeTeam" required>
                                        <option value="">팀을 선택하세요</option>
                                        <c:forEach var="team" items="${teams}">
                                            <option value="${team.teamId}" ${game.homeTeam == team.teamId ? 'selected' : ''}>
                                                    ${team.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="status" class="form-label fw-semibold">
                                        <i class="fas fa-flag me-2 text-info"></i>경기 상태 *
                                    </label>
                                    <select class="form-select" id="status" name="status" required onchange="toggleScoreFields()">
                                        <option value="SCHEDULED" ${game.status == 'SCHEDULED' ? 'selected' : ''}>
                                            <i class="fas fa-clock"></i> 예정
                                        </option>
                                        <option value="COMPLETED" ${game.status == 'COMPLETED' ? 'selected' : ''}>
                                            <i class="fas fa-check-circle"></i> 완료
                                        </option>
                                        <option value="CANCELED" ${game.status == 'CANCELED' ? 'selected' : ''}>
                                            <i class="fas fa-times-circle"></i> 취소
                                        </option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 경기 결과 -->
                    <div class="col-md-6">
                        <div class="card border-0 bg-light bg-opacity-50 mb-4">
                            <div class="card-body">
                                <h5 class="mb-4 fw-bold text-success">
                                    <i class="fas fa-trophy me-2"></i>경기 결과
                                </h5>

                                <div id="scoreFields">
                                    <div class="mb-3">
                                        <label for="awayScore" class="form-label fw-semibold">
                                            <i class="fas fa-plane me-2 text-warning"></i>원정팀 점수
                                        </label>
                                        <input type="number" class="form-control" id="awayScore" name="awayScore"
                                               value="${game.awayScore}" min="0" max="50">
                                    </div>

                                    <div class="mb-3">
                                        <label for="homeScore" class="form-label fw-semibold">
                                            <i class="fas fa-home me-2 text-success"></i>홈팀 점수
                                        </label>
                                        <input type="number" class="form-control" id="homeScore" name="homeScore"
                                               value="${game.homeScore}" min="0" max="50">
                                    </div>

                                    <div class="mb-3">
                                        <label for="winner" class="form-label fw-semibold">
                                            <i class="fas fa-crown me-2 text-warning"></i>승리팀
                                        </label>
                                        <select class="form-select" id="winner" name="winner">
                                            <option value="">승부 결과 선택</option>
                                            <option value="" id="awayTeamWin" style="display: none;"></option>
                                            <option value="" id="homeTeamWin" style="display: none;"></option>
                                            <option value="무승부" ${game.winner == '무승부' ? 'selected' : ''}>무승부</option>
                                        </select>
                                    </div>
                                </div>

                                <h5 class="mt-4 mb-3 fw-bold text-info">
                                    <i class="fas fa-baseball-ball me-2"></i>투수 정보
                                </h5>

                                <div class="mb-3">
                                    <label for="awayPitcher" class="form-label fw-semibold">
                                        <i class="fas fa-plane me-2 text-warning"></i>원정팀 선발투수
                                    </label>
                                    <input type="text" class="form-control" id="awayPitcher" name="awayPitcher"
                                           value="${game.awayPitcher}" placeholder="투수 이름">
                                </div>

                                <div class="mb-3">
                                    <label for="awayPitcherResult" class="form-label fw-semibold">원정팀 투수 결과</label>
                                    <select class="form-select" id="awayPitcherResult" name="awayPitcherResult">
                                        <option value="">결과 선택</option>
                                        <option value="승" ${game.awayPitcherResult == '승' ? 'selected' : ''}>승</option>
                                        <option value="패" ${game.awayPitcherResult == '패' ? 'selected' : ''}>패</option>
                                        <option value="무" ${game.awayPitcherResult == '무' ? 'selected' : ''}>무</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="homePitcher" class="form-label fw-semibold">
                                        <i class="fas fa-home me-2 text-success"></i>홈팀 선발투수
                                    </label>
                                    <input type="text" class="form-control" id="homePitcher" name="homePitcher"
                                           value="${game.homePitcher}" placeholder="투수 이름">
                                </div>

                                <div class="mb-3">
                                    <label for="homePitcherResult" class="form-label fw-semibold">홈팀 투수 결과</label>
                                    <select class="form-select" id="homePitcherResult" name="homePitcherResult">
                                        <option value="">결과 선택</option>
                                        <option value="승" ${game.homePitcherResult == '승' ? 'selected' : ''}>승</option>
                                        <option value="패" ${game.homePitcherResult == '패' ? 'selected' : ''}>패</option>
                                        <option value="무" ${game.homePitcherResult == '무' ? 'selected' : ''}>무</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="etc" class="form-label fw-semibold">
                                        <i class="fas fa-sticky-note me-2 text-secondary"></i>기타 정보
                                    </label>
                                    <textarea class="form-control" id="etc" name="etc" rows="3"
                                              placeholder="기타 정보나 특이사항을 입력하세요">${game.etc}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <button type="submit" class="btn btn-primary btn-custom btn-lg me-3">
                        <i class="fas fa-save me-2"></i>${game != null ? '수정 완료' : '경기 추가'}
                    </button>
                    <a href="${pageContext.request.contextPath}/admin?action=games" class="btn btn-secondary btn-custom btn-lg">
                        <i class="fas fa-times me-2"></i>취소
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />

<script>
    function toggleScoreFields() {
        const status = document.getElementById('status').value;
        const scoreFields = document.getElementById('scoreFields');

        if (status === 'COMPLETED') {
            scoreFields.style.display = 'block';
            document.getElementById('awayScore').required = true;
            document.getElementById('homeScore').required = true;
        } else {
            scoreFields.style.display = 'none';
            document.getElementById('awayScore').required = false;
            document.getElementById('homeScore').required = false;
            // 값 초기화
            document.getElementById('awayScore').value = '';
            document.getElementById('homeScore').value = '';
            document.getElementById('winner').value = '';
        }
    }

    function updateWinnerOptions() {
        const awayTeamSelect = document.getElementById('awayTeam');
        const homeTeamSelect = document.getElementById('homeTeam');
        const winnerSelect = document.getElementById('winner');
        const awayTeamWin = document.getElementById('awayTeamWin');
        const homeTeamWin = document.getElementById('homeTeamWin');

        if (awayTeamSelect.value && homeTeamSelect.value) {
            const awayTeamName = awayTeamSelect.options[awayTeamSelect.selectedIndex].text;
            const homeTeamName = homeTeamSelect.options[homeTeamSelect.selectedIndex].text;

            awayTeamWin.value = awayTeamName;
            awayTeamWin.textContent = awayTeamName + ' 승리';
            awayTeamWin.style.display = 'block';

            homeTeamWin.value = homeTeamName;
            homeTeamWin.textContent = homeTeamName + ' 승리';
            homeTeamWin.style.display = 'block';

            // 기존 선택된 승리팀이 있다면 유지
            if ('${game.winner}' && '${game.winner}' !== '무승부') {
                if ('${game.winner}' === awayTeamName) {
                    awayTeamWin.selected = true;
                } else if ('${game.winner}' === homeTeamName) {
                    homeTeamWin.selected = true;
                }
            }
        } else {
            awayTeamWin.style.display = 'none';
            homeTeamWin.style.display = 'none';
        }
    }

    // 페이지 로드 시 상태에 따라 필드 표시/숨김
    document.addEventListener('DOMContentLoaded', function() {
        toggleScoreFields();
        updateWinnerOptions();

        // 애니메이션 효과
        const cards = document.querySelectorAll('.fade-in-up');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';

            setTimeout(() => {
                card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 200);
        });
    });

    // 팀 선택 시 승리팀 옵션 업데이트
    document.getElementById('awayTeam').addEventListener('change', function() {
        const awayTeamId = this.value;
        const homeTeamSelect = document.getElementById('homeTeam');

        if (awayTeamId && homeTeamSelect.value === awayTeamId) {
            alert('홈팀과 원정팀은 같을 수 없습니다.');
            this.value = '';
        }
        updateWinnerOptions();
    });

    document.getElementById('homeTeam').addEventListener('change', function() {
        const homeTeamId = this.value;
        const awayTeamSelect = document.getElementById('awayTeam');

        if (homeTeamId && awayTeamSelect.value === homeTeamId) {
            alert('홈팀과 원정팀은 같을 수 없습니다.');
            this.value = '';
        }
        updateWinnerOptions();
    });

    // 점수 입력 시 자동으로 승리팀 설정
    document.getElementById('awayScore').addEventListener('input', autoSetWinner);
    document.getElementById('homeScore').addEventListener('input', autoSetWinner);

    function autoSetWinner() {
        const awayScore = parseInt(document.getElementById('awayScore').value) || 0;
        const homeScore = parseInt(document.getElementById('homeScore').value) || 0;
        const winnerSelect = document.getElementById('winner');
        const awayTeamWin = document.getElementById('awayTeamWin');
        const homeTeamWin = document.getElementById('homeTeamWin');

        if (awayScore > homeScore && awayScore > 0) {
            winnerSelect.value = awayTeamWin.value;
        } else if (homeScore > awayScore && homeScore > 0) {
            winnerSelect.value = homeTeamWin.value;
        } else if (awayScore === homeScore && awayScore > 0) {
            winnerSelect.value = '무승부';
        } else {
            winnerSelect.value = '';
        }
    }

    // 폼 제출 전 유효성 검사
    document.querySelector('form').addEventListener('submit', function(e) {
        const status = document.getElementById('status').value;

        if (status === 'COMPLETED') {
            const awayScore = document.getElementById('awayScore').value;
            const homeScore = document.getElementById('homeScore').value;
            const winner = document.getElementById('winner').value;

            if (!awayScore || !homeScore) {
                e.preventDefault();
                alert('완료된 경기는 점수를 입력해야 합니다.');
                return;
            }

            if (!winner) {
                e.preventDefault();
                alert('완료된 경기는 승리팀을 선택해야 합니다.');
                return;
            }
        }
    });
</script>
