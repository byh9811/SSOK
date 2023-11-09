package com.ssok.idcard.global.util;

import com.ssok.idcard.global.openfeign.naver.dto.response.LicenseOcrResponse;
import com.ssok.idcard.global.openfeign.naver.dto.response.RegistrationCardOcrResponse;

import java.time.LocalDate;

public class DateUtil {

    public static LocalDate toLocalDate(LicenseOcrResponse.DateObject date) {
        return LocalDate.of(Integer.parseInt(date.getYear()), Integer.parseInt(date.getMonth()), Integer.parseInt(date.getDay()));
    }

    public static LocalDate toLocalDate(RegistrationCardOcrResponse.DateObject date) {
        return LocalDate.of(Integer.parseInt(date.getYear()), Integer.parseInt(date.getMonth()), Integer.parseInt(date.getDay()));
    }

}
