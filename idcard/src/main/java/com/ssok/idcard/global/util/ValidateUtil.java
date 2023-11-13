package com.ssok.idcard.global.util;

import org.springframework.stereotype.Component;

import java.util.regex.Pattern;

@Component
public class ValidateUtil {

    public static final Pattern PERSONAL_NUMBER_PATTERN = Pattern.compile("\\d{6}-\\d{7}");

}
