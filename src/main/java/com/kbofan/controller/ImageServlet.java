package com.kbofan.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 경로에서 파일명 추출 (예: /community/filename.jpg)
        String fileName = pathInfo.substring(1); // 앞의 / 제거

        // 실제 파일 경로 구성
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR + File.separator + fileName;
        Path filePath = Paths.get(uploadPath);

        // 파일 존재 여부 확인
        if (!Files.exists(filePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // MIME 타입 설정
        String mimeType = getServletContext().getMimeType(uploadPath);
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);

        // 파일 크기 설정
        response.setContentLengthLong(Files.size(filePath));

        // 캐시 헤더 설정
        response.setHeader("Cache-Control", "public, max-age=31536000"); // 1년
        response.setDateHeader("Expires", System.currentTimeMillis() + 31536000000L);

        // 파일 내용을 응답으로 전송
        try (InputStream inputStream = Files.newInputStream(filePath);
             OutputStream outputStream = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        }
    }
}