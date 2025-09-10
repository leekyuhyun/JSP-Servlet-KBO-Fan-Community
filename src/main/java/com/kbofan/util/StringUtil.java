package com.kbofan.util;

import java.util.regex.Pattern;

public class StringUtil {
    // 문자열이 null이거나 빈 문자열인지 확인
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    // 문자열이 null이 아니고 빈 문자열이 아닌지 확인
    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }

    // HTML 태그 제거
    public static String removeHtmlTags(String html) {
        if (isEmpty(html)) {
            return "";
        }
        return html.replaceAll("<[^>]*>", "");
    }

    // 문자열 길이 제한
    public static String truncate(String str, int maxLength) {
        if (isEmpty(str)) {
            return "";
        }

        if (str.length() <= maxLength) {
            return str;
        }

        return str.substring(0, maxLength) + "...";
    }

    // 이메일 유효성 검사
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) {
            return false;
        }

        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return Pattern.compile(emailRegex).matcher(email).matches();
    }

    // 비밀번호 유효성 검사 (8자 이상, 영문, 숫자, 특수문자 포함)
    public static boolean isValidPassword(String password) {
        if (isEmpty(password) || password.length() < 8) {
            return false;
        }

        boolean hasLetter = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for (char c : password.toCharArray()) {
            if (Character.isLetter(c)) {
                hasLetter = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            } else {
                hasSpecial = true;
            }
        }

        return hasLetter && hasDigit && hasSpecial;
    }

    // XSS 방지를 위한 문자열 이스케이프
    public static String escapeHtml(String html) {
        if (isEmpty(html)) {
            return "";
        }

        return html.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}