package com.kbofan.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * DBUtil 클래스
 * - JDBC를 사용하여 MySQL DB 연결 및 자원 해제를 관리하는 유틸리티 클래스
 */
public class DBUtil {

    // JDBC 드라이버 및 DB 연결 정보 상수 정의
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver"; // MySQL 8.x 드라이버
    private static final String DB_URL = "jdbc:mysql://localhost:3306/kbo_community?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8"; // DB URL
    private static final String USER = "root";   // DB 사용자 계정
    private static final String PASS = "1234";   // DB 비밀번호

    // JDBC 드라이버 로딩 (클래스가 처음 로딩될 때 한 번 실행됨)
    static {
        try {
            Class.forName(JDBC_DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace(); // 드라이버 로딩 실패 시 예외 출력
        }
    }

    /**
     * DB 연결 객체(Connection)를 반환
     * @return Connection 객체
     * @throws SQLException DB 연결 실패 시 발생
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (SQLException e) {
            throw e; // 호출자에게 예외 전달
        }
    }

    /**
     * DB 자원(Connection, PreparedStatement, ResultSet) 해제
     * @param conn Connection 객체
     * @param pstmt PreparedStatement 객체
     * @param rs ResultSet 객체
     */
    public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();           // ResultSet 닫기
            if (pstmt != null) pstmt.close();     // PreparedStatement 닫기
            if (conn != null) conn.close();       // Connection 닫기 (Connection Pool 사용 시 반환)
        } catch (SQLException e) {
            e.printStackTrace(); // 자원 해제 중 예외 출력
        }
    }

    /**
     * DB 자원(Connection, PreparedStatement) 해제 (ResultSet 없는 경우)
     * @param conn Connection 객체
     * @param pstmt PreparedStatement 객체
     */
    public static void close(Connection conn, PreparedStatement pstmt) {
        close(conn, pstmt, null); // ResultSet은 null로 넘겨 처리
    }
}
