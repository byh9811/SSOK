package com.ssok.namecard.global.api;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.springframework.http.HttpStatus;

public class ApiError {

    //에러 코드
    private final String code;

    //에러 메시지
    private final String message;
    //에러 상태
    private final HttpStatus status;

    ApiError(String code, String message, HttpStatus status){
        this.code = code;
        this.message = message;
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public HttpStatus getStatus() {
        return status;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("message", message)
                .append("status", status)
                .toString();
    }

}