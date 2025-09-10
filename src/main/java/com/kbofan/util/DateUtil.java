package com.kbofan.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {
    // 날짜 포맷 상수
    private static final String DATE_FORMAT = "yyyy-MM-dd";
    private static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    private static final String TIME_FORMAT = "HH:mm:ss";

    // 날짜를 문자열로 변환
    public static String formatDate(Date date) {
        if (date == null) {
            return "";
        }
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        return sdf.format(date);
    }

    // 날짜와 시간을 문자열로 변환
    public static String formatDateTime(Date date) {
        if (date == null) {
            return "";
        }
        SimpleDateFormat sdf = new SimpleDateFormat(DATETIME_FORMAT);
        return sdf.format(date);
    }

    // 시간을 문자열로 변환
    public static String formatTime(Date date) {
        if (date == null) {
            return "";
        }
        SimpleDateFormat sdf = new SimpleDateFormat(TIME_FORMAT);
        return sdf.format(date);
    }

    // 현재 날짜와 시간 가져오기
    public static Date getCurrentDateTime() {
        return new Date();
    }

    // 날짜 차이 계산 (일 단위)
    public static long getDaysDifference(Date date1, Date date2) {
        long diff = date2.getTime() - date1.getTime();
        return diff / (24 * 60 * 60 * 1000);
    }

    // 시간 차이 계산 (시간 단위)
    public static long getHoursDifference(Date date1, Date date2) {
        long diff = date2.getTime() - date1.getTime();
        return diff / (60 * 60 * 1000);
    }

    // 분 차이 계산 (분 단위)
    public static long getMinutesDifference(Date date1, Date date2) {
        long diff = date2.getTime() - date1.getTime();
        return diff / (60 * 1000);
    }
}