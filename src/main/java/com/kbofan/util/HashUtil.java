package com.kbofan.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

/**
 * HashUtil 클래스
 * - SHA-256 알고리즘을 이용한 비밀번호 해싱 및 검증 기능 제공
 */
public class HashUtil {
    /**
     * 비밀번호 해싱 메서드
     * 입력된 평문 비밀번호를 SHA-256 알고리즘으로 해싱한 후 Base64 문자열로 반환
     *
     * @param password 해싱할 비밀번호 (평문)
     * @return 해싱된 비밀번호 (Base64 인코딩 문자열)
     */
    public static String hashPassword(String password) {
        try {
            // SHA-256 해시 객체 생성
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            // 비밀번호를 바이트 배열로 변환하여 해시 처리
            byte[] hashedBytes = md.digest(password.getBytes());
            // Base64로 인코딩하여 문자열로 반환
            return Base64.getEncoder().encodeToString(hashedBytes);
        } catch (NoSuchAlgorithmException e) {
            // SHA-256 알고리즘이 존재하지 않을 경우 예외 발생
            e.printStackTrace();
            return null;
        }
    }
    /**
     * 비밀번호 일치 여부 확인 메서드
     * 입력한 평문 비밀번호를 해싱하여 기존 해시값과 비교
     *
     * @param password 사용자가 입력한 평문 비밀번호
     * @param hashedPassword DB 등에 저장된 해시된 비밀번호
     * @return 일치하면 true, 불일치하면 false
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        // 입력된 비밀번호를 해싱
        String hashedInput = hashPassword(password);
        // null이 아니고, 해시 결과가 저장된 해시값과 동일하면 일치
        return hashedInput != null && hashedInput.equals(hashedPassword);
    }
}
