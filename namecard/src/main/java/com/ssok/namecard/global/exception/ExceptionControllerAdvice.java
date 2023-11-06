package com.ssok.namecard.global.exception;


import com.ssok.namecard.global.api.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RestControllerAdvice
public class ExceptionControllerAdvice {

    @ExceptionHandler(BaseException.class)
    ApiResponse<?> exceptionHandler(BaseException e){
        log.error("예외가 발생했습니다: {}", e.getMessage());
        return ApiResponse.ERROR(e.getErrorCode().getCode(), e.getErrorCode().getHttpStatus(), e.getErrorCode().getMessage());
    }
}
