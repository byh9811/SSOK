package com.ssok.namecard.global.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {
    NAMECARD_NOT_FOUND("NAMECARD_01", HttpStatus.NOT_FOUND, "존재하지 않는 명함입니다.");

    private final String code;
    private final HttpStatus httpStatus;
    private final String message;
}
