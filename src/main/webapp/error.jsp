<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오류 발생 - KBO Fan</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="/includes/header.jsp" />

<div class="container mt-5">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card">
                <div class="card-header bg-danger text-white">
                    <h4 class="mb-0">
                        <%
                            int statusCode = response.getStatus();
                            if (statusCode == 404) {
                                out.print("404 - 페이지를 찾을 수 없습니다");
                            } else if (statusCode == 500) {
                                out.print("500 - 서버 오류가 발생했습니다");
                            } else {
                                out.print("오류가 발생했습니다");
                            }
                        %>
                    </h4>
                </div>
                <div class="card-body">
                    <%
                        if (statusCode == 404) {
                    %>
                    <p class="lead">요청하신 페이지가 존재하지 않거나, 이동되었거나, 삭제되었을 수 있습니다.</p>
                    <p>URL을 다시 확인하시거나 아래 버튼을 통해 다른 페이지로 이동해주세요.</p>
                    <%
                    } else if (statusCode == 500) {
                    %>
                    <p class="lead">요청을 처리하는 중에 서버에서 오류가 발생했습니다.</p>
                    <p>잠시 후 다시 시도해주세요. 문제가 계속되면 관리자에게 문의해주세요.</p>
                    <%
                    } else {
                    %>
                    <p class="lead">요청을 처리하는 중 예기치 않은 오류가 발생했습니다.</p>
                    <%
                        }
                    %>

                    <% if (exception != null) { %>
                    <div class="alert alert-danger">
                        <h5>오류 메시지:</h5>
                        <p><%= exception.getMessage() %></p>
                    </div>

                    <%
                        // 관리자인 경우에만 스택 트레이스 표시
                        boolean isAdmin = request.isUserInRole("admin");
                        if (isAdmin) {
                    %>
                    <div class="mt-4">
                        <h5>스택 트레이스:</h5>
                        <pre class="bg-light p-3 rounded"><code>
<% for (StackTraceElement element : exception.getStackTrace()) { %>
<%= element.toString() %>
<% } %>
                            </code></pre>
                    </div>
                    <% } %>
                    <% } %>

                    <div class="mt-4 d-flex gap-2">
                        <a href="javascript:history.back()" class="btn btn-secondary">이전 페이지로</a>
                        <a href="<%= request.getContextPath() %>/" class="btn btn-primary">홈으로</a>
                        <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-info">로그인 페이지로</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>