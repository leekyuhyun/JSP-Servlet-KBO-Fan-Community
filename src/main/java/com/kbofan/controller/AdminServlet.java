package com.kbofan.controller;

import com.kbofan.dao.CommunityDAO;
import com.kbofan.dao.GameDAO;
import com.kbofan.dao.TeamDAO;
import com.kbofan.dao.UserDAO;
import com.kbofan.dto.Community;
import com.kbofan.dto.Game;
import com.kbofan.dto.Team;
import com.kbofan.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private UserDAO userDAO;
    private CommunityDAO communityDAO;
    private GameDAO gameDAO;
    private TeamDAO teamDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        communityDAO = new CommunityDAO();
        gameDAO = new GameDAO();
        teamDAO = new TeamDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 관리자 권한 확인
        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard"; // 기본값
        }

        try {
            switch (action) {
                case "dashboard":
                    handleDashboard(request, response);
                    break;
                case "users":
                    handleUsers(request, response);
                    break;
                case "posts":
                    handlePosts(request, response);
                    break;
                case "games":
                    handleGames(request, response);
                    break;
                case "game-form":
                    handleGameForm(request, response);
                    break;
                default:
                    handleDashboard(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "시스템 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 관리자 권한 확인
        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        try {
            switch (action) {
                case "deleteUser":
                    handleDeleteUser(request, response);
                    break;
                case "deletePost":
                    handleDeletePost(request, response);
                    break;
                case "addGame":
                case "updateGame":
                    handleGameSave(request, response, action);
                    break;
                case "deleteGame":
                    handleDeleteGame(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?error=system_error");
        }
    }

    // 관리자 권한 확인
    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=login_required");
            return false;
        } else if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/main.jsp?error=access_denied");
            return false;
        }
        return true;
    }

    // 대시보드 처리
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 통계 데이터 조회
        int totalUsers = userDAO.getTotalUserCount();
        int totalPosts = communityDAO.getTotalPostCount();
        int totalGames = gameDAO.getTotalGameCount();
        int todayGames = gameDAO.getTodayGameCount();
        int newUsers = userDAO.getNewUserCount(7);

        // 최근 게시글 조회
        List<Community> recentPosts = communityDAO.getCommunityList("all", "all", "", 1, 5);

        // 최근 경기 조회
        List<Game> recentGames = gameDAO.getRecentGames(5);

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("totalGames", totalGames);
        request.setAttribute("todayGames", todayGames);
        request.setAttribute("newUsers", newUsers);
        request.setAttribute("recentPosts", recentPosts);
        request.setAttribute("recentGames", recentGames);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    // 사용자 관리 처리
    private void handleUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchType = request.getParameter("searchType");
        String searchKeyword = request.getParameter("searchKeyword");
        String pageParam = request.getParameter("page");

        if (searchType == null) searchType = "all";
        if (searchKeyword == null) searchKeyword = "";

        int page = 1;
        int pageSize = 20;

        try {
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        List<User> users = userDAO.getUserList(searchType, searchKeyword, page, pageSize);
        int totalCount = userDAO.getTotalUserCount(searchType, searchKeyword);
        int totalPages = (totalCount > 0) ? (int) Math.ceil((double) totalCount / pageSize) : 1;

        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchKeyword", searchKeyword);

        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    // 게시글 관리 처리
    private void handlePosts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String searchType = request.getParameter("searchType");
        String searchKeyword = request.getParameter("searchKeyword");
        String pageParam = request.getParameter("page");

        if (category == null) category = "all";
        if (searchType == null) searchType = "all";
        if (searchKeyword == null) searchKeyword = "";

        int page = 1;
        int pageSize = 20;

        try {
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        List<Community> posts = communityDAO.getCommunityList(category, searchType, searchKeyword, page, pageSize);
        int totalCount = communityDAO.getTotalCount(category, searchType, searchKeyword);
        int totalPages = (totalCount > 0) ? (int) Math.ceil((double) totalCount / pageSize) : 1;

        request.setAttribute("posts", posts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("category", category);
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchKeyword", searchKeyword);

        request.getRequestDispatcher("/admin/posts.jsp").forward(request, response);
    }

    // 경기 관리 처리
    private void handleGames(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dateParam = request.getParameter("date");
        Date selectedDate = new Date();

        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                selectedDate = sdf.parse(dateParam);
            } catch (ParseException e) {
                selectedDate = new Date();
            }
        }

        List<Game> games = gameDAO.getGamesByDate(selectedDate);
        List<Team> teams = teamDAO.getAllTeams();

        request.setAttribute("games", games);
        request.setAttribute("teams", teams);
        request.setAttribute("selectedDate", selectedDate);

        request.getRequestDispatcher("/admin/games.jsp").forward(request, response);
    }

    // 경기 폼 처리
    private void handleGameForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String gameIdParam = request.getParameter("gameId");
        List<Team> teams = teamDAO.getAllTeams();

        request.setAttribute("teams", teams);

        if (gameIdParam != null && !gameIdParam.trim().isEmpty()) {
            try {
                int gameId = Integer.parseInt(gameIdParam);
                Game game = gameDAO.getGameById(gameId);
                request.setAttribute("game", game);
            } catch (NumberFormatException e) {
                // 잘못된 게임 ID
            }
        }

        request.getRequestDispatcher("/admin/game-form.jsp").forward(request, response);
    }

    // 사용자 삭제 처리
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdParam = request.getParameter("userId");
        if (userIdParam != null) {
            try {
                int userId = Integer.parseInt(userIdParam);
                boolean success = userDAO.deleteUser(userId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=users&success=user_deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin?action=users&error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin?action=users&error=invalid_id");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin?action=users");
        }
    }

    // 게시글 삭제 처리
    private void handleDeletePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String postIdParam = request.getParameter("postId");
        if (postIdParam != null) {
            try {
                int postId = Integer.parseInt(postIdParam);
                boolean success = communityDAO.deletePostByAdmin(postId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=posts&success=post_deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin?action=posts&error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin?action=posts&error=invalid_id");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin?action=posts");
        }
    }

    // 경기 삭제 처리
    private void handleDeleteGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String gameIdParam = request.getParameter("gameId");
        if (gameIdParam != null) {
            try {
                int gameId = Integer.parseInt(gameIdParam);
                boolean success = gameDAO.deleteGame(gameId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=games&success=game_deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin?action=games&error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin?action=games&error=invalid_id");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin?action=games");
        }
    }

    // 경기 저장 처리
    private void handleGameSave(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {

        try {
            Game game = new Game();

            // 기본 정보
            String gameDate = request.getParameter("gameDate");
            String gameTime = request.getParameter("gameTime");
            String stadium = request.getParameter("stadium");
            String awayTeamParam = request.getParameter("awayTeam");
            String homeTeamParam = request.getParameter("homeTeam");
            String status = request.getParameter("status");

            // 점수 정보
            String awayScoreParam = request.getParameter("awayScore");
            String homeScoreParam = request.getParameter("homeScore");

            // 투수 정보
            String awayPitcher = request.getParameter("awayPitcher");
            String awayPitcherResult = request.getParameter("awayPitcherResult");
            String homePitcher = request.getParameter("homePitcher");
            String homePitcherResult = request.getParameter("homePitcherResult");

            String winner = request.getParameter("winner");
            String etc = request.getParameter("etc");

            // 날짜 파싱
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            game.setGameDate(sdf.parse(gameDate));
            game.setGameTime(gameTime);
            game.setStadium(stadium);
            game.setAwayTeam(Integer.parseInt(awayTeamParam));
            game.setHomeTeam(Integer.parseInt(homeTeamParam));
            game.setStatus(status);

            // 점수 설정 (완료된 경기만)
            if ("COMPLETED".equals(status)) {
                if (awayScoreParam != null && !awayScoreParam.trim().isEmpty()) {
                    game.setAwayScore(Integer.parseInt(awayScoreParam));
                }
                if (homeScoreParam != null && !homeScoreParam.trim().isEmpty()) {
                    game.setHomeScore(Integer.parseInt(homeScoreParam));
                }
                game.setWinner(winner);
            }

            game.setAwayPitcher(awayPitcher);
            game.setAwayPitcherResult(awayPitcherResult);
            game.setHomePitcher(homePitcher);
            game.setHomePitcherResult(homePitcherResult);
            game.setEtc(etc);

            boolean success = false;
            if ("addGame".equals(action)) {
                success = gameDAO.addGame(game);
            } else if ("updateGame".equals(action)) {
                String gameIdParam = request.getParameter("gameId");
                game.setGameId(Integer.parseInt(gameIdParam));
                success = gameDAO.updateGame(game);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin?action=games&success=game_saved");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin?action=games&error=save_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?action=games&error=invalid_data");
        }
    }
}
