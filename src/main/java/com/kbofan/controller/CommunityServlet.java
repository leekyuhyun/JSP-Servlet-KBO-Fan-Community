package com.kbofan.controller;

import com.kbofan.dao.CommunityDAO;
import com.kbofan.dto.Community;
import com.kbofan.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

@WebServlet(urlPatterns = {"/community"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 5,       // 5MB
        maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class CommunityServlet extends HttpServlet {
    private CommunityDAO communityDAO;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    public void init() throws ServletException {
        communityDAO = new CommunityDAO();

        // 업로드 디렉토리 생성
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        System.out.println("CommunityServlet 초기화 완료");
        System.out.println("업로드 경로: " + uploadPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        System.out.println("=== CommunityServlet GET 요청 ===");
        System.out.println("Action 파라미터: " + action);
        System.out.println("RequestURI: " + request.getRequestURI());

        // action 파라미터가 없으면 기본값을 list로 설정
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        System.out.println("최종 Action: " + action);

        try {
            switch (action) {
                case "list":
                    handleList(request, response);
                    break;
                case "view":
                    handleView(request, response);
                    break;
                case "write":
                    handleWriteForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                default:
                    System.out.println("알 수 없는 action: " + action);
                    handleList(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("CommunityServlet doGet 오류: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "시스템 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        System.out.println("=== CommunityServlet POST 요청 ===");
        System.out.println("Action: " + action);

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/community");
            return;
        }

        try {
            switch (action) {
                case "create":
                    handleCreate(request, response);
                    break;
                case "update":
                    handleUpdate(request, response);
                    break;
                case "delete":
                    handleDelete(request, response);
                    break;
                case "comment":
                    handleComment(request, response);
                    break;
                case "comment_delete":
                    handleCommentDelete(request, response);
                    break;
                case "like":
                    handleLike(request, response);
                    break;
                case "comment_like":
                    handleCommentLike(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/community");
                    break;
            }
        } catch (Exception e) {
            System.err.println("CommunityServlet doPost 오류: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/community?error=system_error");
        }
    }

    // 이미지 파일 업로드 처리 (수정된 버전)
    private String handleImageUpload(HttpServletRequest request) throws IOException, ServletException {
        Part imagePart = request.getPart("image");

        if (imagePart == null || imagePart.getSize() == 0) {
            return null; // 이미지가 없는 경우
        }

        String fileName = imagePart.getSubmittedFileName();
        if (fileName == null || fileName.trim().isEmpty()) {
            return null;
        }

        System.out.println("업로드된 파일명: " + fileName);
        System.out.println("파일 크기: " + imagePart.getSize());

        // 파일 확장자 검사
        String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        if (!fileExtension.matches("\\.(jpg|jpeg|png|gif)$")) {
            throw new ServletException("지원하지 않는 파일 형식입니다.");
        }

        // 업로드 디렉토리 경로 - community 하위 폴더 생성
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // community 하위 디렉토리 생성
        File communityDir = new File(uploadPath + File.separator + "community");
        if (!communityDir.exists()) {
            communityDir.mkdirs();
        }

        // 고유한 파일명 생성
        String uniqueFileName = "community_" + UUID.randomUUID().toString() + fileExtension;
        String filePath = communityDir.getAbsolutePath() + File.separator + uniqueFileName;

        System.out.println("저장될 파일 경로: " + filePath);

        // 파일 저장
        try {
            imagePart.write(filePath);
            System.out.println("파일 저장 완료: " + uniqueFileName);

            // 웹에서 접근 가능한 경로 반환 (ImageServlet에서 처리할 수 있도록)
            return "community/" + uniqueFileName;
        } catch (Exception e) {
            System.err.println("파일 저장 실패: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("파일 저장에 실패했습니다.");
        }
    }

    // 게시글 목록 처리
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println("=== handleList 시작 ===");

            // 파라미터 받기
            String category = request.getParameter("category");
            String searchType = request.getParameter("searchType");
            String searchKeyword = request.getParameter("searchKeyword");
            String pageParam = request.getParameter("page");

            // 기본값 설정
            if (category == null) category = "all";
            if (searchType == null) searchType = "all";
            if (searchKeyword == null) searchKeyword = "";

            int page = 1;
            int pageSize = 15;

            try {
                if (pageParam != null && !pageParam.trim().isEmpty()) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }

            System.out.println("파라미터 - category: " + category + ", page: " + page + ", searchKeyword: " + searchKeyword);

            // 데이터 조회
            List<Community> communities = communityDAO.getCommunityList(category, searchType, searchKeyword, page, pageSize);
            int totalCount = communityDAO.getTotalCount(category, searchType, searchKeyword);
            int totalPages = (totalCount > 0) ? (int) Math.ceil((double) totalCount / pageSize) : 1;

            // 페이지네이션 정보 계산
            int startPage = ((page - 1) / 10) * 10 + 1;
            int endPage = Math.min(startPage + 9, totalPages);

            // request에 데이터 설정
            request.setAttribute("communities", communities);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("category", category);
            request.setAttribute("searchType", searchType);
            request.setAttribute("searchKeyword", searchKeyword);

            System.out.println("데이터 설정 완료 - totalCount: " + totalCount + ", communities size: " + communities.size());

            // JSP로 포워드
            String jspPath = "/community/list.jsp";
            System.out.println("JSP 포워드: " + jspPath);
            request.getRequestDispatcher(jspPath).forward(request, response);

        } catch (Exception e) {
            System.err.println("handleList 오류: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "게시글 목록을 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    // 게시글 상세보기 처리
    private void handleView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        System.out.println("=== handleView 시작 ===");
        System.out.println("ID 파라미터: " + idParam);

        if (idParam == null || idParam.trim().isEmpty()) {
            System.out.println("ID 파라미터가 없음, 목록으로 리다이렉션");
            response.sendRedirect(request.getContextPath() + "/community");
            return;
        }

        try {
            int communityId = Integer.parseInt(idParam);
            System.out.println("파싱된 communityId: " + communityId);

            // 현재 사용자 정보 가져오기
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            int currentUserId = (currentUser != null) ? currentUser.getUserId() : 0;
            System.out.println("현재 사용자 ID: " + currentUserId);

            // 게시글 조회
            Community community = communityDAO.getCommunityById(communityId, currentUserId);
            if (community == null) {
                System.out.println("게시글을 찾을 수 없음");
                response.sendRedirect(request.getContextPath() + "/community?error=not_found");
                return;
            }

            System.out.println("게시글 조회 성공: " + community.getTitle());
            System.out.println("이미지 경로: " + community.getImagePath());

            // 조회수 증가
            communityDAO.incrementViewCount(communityId);

            // 댓글 목록 조회
            List<Community> comments = communityDAO.getCommentsByCommunityId(communityId, currentUserId);
            System.out.println("댓글 수: " + comments.size());

            // request에 데이터 설정
            request.setAttribute("community", community);
            request.setAttribute("comments", comments);

            // JSP로 포워드
            String jspPath = "/community/view.jsp";
            System.out.println("JSP 포워드: " + jspPath);
            request.getRequestDispatcher(jspPath).forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("ID 파라미터 형식 오류: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/community?error=invalid_id");
        } catch (Exception e) {
            System.err.println("handleView 오류: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/community?error=system_error");
        }
    }

    // 게시글 작성 폼 처리
    private void handleWriteForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== handleWriteForm 시작 ===");

        // 로그인 체크
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            System.out.println("로그인되지 않은 사용자");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_logged_in");
            return;
        }

        System.out.println("작성 폼으로 포워드");
        request.getRequestDispatcher("/community/write.jsp").forward(request, response);
    }

    // 게시글 수정 폼 처리
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== handleEditForm 시작 ===");

        // 로그인 체크
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_logged_in");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/community");
            return;
        }

        try {
            int communityId = Integer.parseInt(idParam);

            // 게시글 조회
            Community community = communityDAO.getCommunityById(communityId, currentUser.getUserId());
            if (community == null) {
                response.sendRedirect(request.getContextPath() + "/community?error=not_found");
                return;
            }

            // 작성자 권한 확인
            if (community.getAuthorId() != currentUser.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/community?action=view&id=" + communityId + "&error=access_denied");
                return;
            }

            request.setAttribute("community", community);
            request.getRequestDispatcher("/community/edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/community?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/community?error=system_error");
        }
    }

    // 게시글 작성 처리
    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 로그인 체크
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_logged_in");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");

        // 유효성 검사
        if (title == null || title.trim().isEmpty() ||
                content == null || content.trim().isEmpty() ||
                category == null || category.trim().isEmpty()) {

            request.setAttribute("error", "모든 필드를 입력해주세요.");
            request.getRequestDispatcher("/community/write.jsp").forward(request, response);
            return;
        }

        try {
            // 이미지 업로드 처리
            String imagePath = handleImageUpload(request);

            // Community 객체 생성
            Community community = new Community();
            community.setTitle(title.trim());
            community.setContent(content.trim());
            community.setCategory(category);
            community.setAuthorId(currentUser.getUserId());
            community.setImagePath(imagePath);

            System.out.println("게시글 생성 - 이미지 경로: " + imagePath);

            // 게시글 저장
            boolean success = communityDAO.createCommunity(community);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/community?success=post_created");
            } else {
                request.setAttribute("error", "게시글 작성에 실패했습니다.");
                request.getRequestDispatcher("/community/write.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "시스템 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("/community/write.jsp").forward(request, response);
        }
    }

    // 게시글 수정 처리
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 로그인 체크
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_logged_in");
            return;
        }

        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/community");
            return;
        }

        try {
            int communityId = Integer.parseInt(idParam);

            // 유효성 검사
            if (title == null || title.trim().isEmpty() ||
                    content == null || content.trim().isEmpty() ||
                    category == null || category.trim().isEmpty()) {

                Community community = communityDAO.getCommunityById(communityId, currentUser.getUserId());
                request.setAttribute("community", community);
                request.setAttribute("error", "모든 필드를 입력해주세요.");
                request.getRequestDispatcher("/community/edit.jsp").forward(request, response);
                return;
            }

            // 이미지 업로드 처리 (수정 시에는 선택사항)
            String imagePath = handleImageUpload(request);

            // Community 객체 생성
            Community community = new Community();
            community.setCommunityId(communityId);
            community.setTitle(title.trim());
            community.setContent(content.trim());
            community.setCategory(category);
            community.setAuthorId(currentUser.getUserId());
            community.setImagePath(imagePath);

            // 게시글 수정
            boolean success = communityDAO.updateCommunity(community);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/community?action=view&id=" + communityId + "&success=post_updated");
            } else {
                Community originalCommunity = communityDAO.getCommunityById(communityId, currentUser.getUserId());
                request.setAttribute("community", originalCommunity);
                request.setAttribute("error", "게시글 수정에 실패했습니다.");
                request.getRequestDispatcher("/community/edit.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/community?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/community?error=system_error");
        }
    }

    // 게시글 삭제 처리
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 로그인 체크
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_logged_in");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/community");
            return;
        }

        try {
            int communityId = Integer.parseInt(idParam);

            // 게시글 삭제
            boolean success = communityDAO.deleteCommunity(communityId, currentUser.getUserId());

            if (success) {
                response.sendRedirect(request.getContextPath() + "/community?success=post_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/community?action=view&id=" + communityId + "&error=delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/community?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/community?error=system_error");
        }
    }

    // 댓글 작성 처리
    private void handleComment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 로그인 체크
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_logged_in");
            return;
        }

        String idParam = request.getParameter("communityId");
        String content = request.getParameter("content");

        if (idParam == null || idParam.trim().isEmpty() ||
                content == null || content.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/community");
            return;
        }

        try {
            int communityId = Integer.parseInt(idParam);

            // Community 객체 생성 (댓글용)
            Community comment = new Community();
            comment.setCommunityId(communityId);
            comment.setCommentContent(content.trim());
            comment.setCommentAuthorId(currentUser.getUserId());

            // 댓글 저장
            boolean success = communityDAO.createComment(comment);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/community?action=view&id=" + communityId + "#comments");
            } else {
                response.sendRedirect(request.getContextPath() + "/community?action=view&id=" + communityId + "&error=comment_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/community?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/community?error=system_error");
        }
    }

    // 댓글 삭제 처리
    private void handleCommentDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 로그인 체크
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_logged_in");
            return;
        }

        String commentIdParam = request.getParameter("commentId");
        String communityIdParam = request.getParameter("communityId");

        if (commentIdParam == null || commentIdParam.trim().isEmpty() ||
                communityIdParam == null || communityIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/community");
            return;
        }

        try {
            int commentId = Integer.parseInt(commentIdParam);
            int communityId = Integer.parseInt(communityIdParam);

            // 댓글 삭제
            boolean success = communityDAO.deleteComment(commentId, currentUser.getUserId());

            if (success) {
                response.sendRedirect(request.getContextPath() + "/community?action=view&id=" + communityId + "&success=comment_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/community?action=view&id=" + communityId + "&error=comment_delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/community?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/community?error=system_error");
        }
    }

    // 게시글 좋아요 처리 (AJAX)
    private void handleLike(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 로그인 체크
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
            return;
        }

        String idParam = request.getParameter("communityId");
        if (idParam == null || idParam.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"잘못된 요청입니다.\"}");
            return;
        }

        try {
            int communityId = Integer.parseInt(idParam);

            // 좋아요 토글
            boolean success = communityDAO.toggleCommunityLike(communityId, currentUser.getUserId());

            if (success) {
                // 업데이트된 게시글 정보 조회
                Community community = communityDAO.getCommunityById(communityId, currentUser.getUserId());
                out.print("{\"success\": true, \"likeCount\": " + community.getLikeCount() +
                        ", \"isLiked\": " + community.isLikedByCurrentUser() + "}");
            } else {
                out.print("{\"success\": false, \"message\": \"좋아요 처리에 실패했습니다.\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"잘못된 요청입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"시스템 오류가 발생했습니다.\"}");
        }
    }

    // 댓글 좋아요 처리 (AJAX)
    private void handleCommentLike(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 로그인 체크
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
            return;
        }

        String commentIdParam = request.getParameter("commentId");
        if (commentIdParam == null || commentIdParam.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"잘못된 요청입니다.\"}");
            return;
        }

        try {
            int commentId = Integer.parseInt(commentIdParam);

            // 댓글 좋아요 토글
            boolean success = communityDAO.toggleCommentLike(commentId, currentUser.getUserId());

            if (success) {
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"message\": \"좋아요 처리에 실패했습니다.\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"잘못된 요청입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"시스템 오류가 발생했습니다.\"}");
        }
    }


}