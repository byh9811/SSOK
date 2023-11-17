package com.ssok.idcard.global.error;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {

    GCS_EXCEPTION("GCS_EXCEPTION", HttpStatus.BAD_REQUEST, "GCS 업로드시 오류가 발생했습니다.");

    private final String code;
    private final HttpStatus httpStatus;
    private final String message;

}
