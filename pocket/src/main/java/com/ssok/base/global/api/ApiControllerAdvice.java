package com.ssok.base.global.api;

import com.ssok.base.global.exception.CustomException;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.NoSuchElementException;

@RestControllerAdvice
public class ApiControllerAdvice {

    /**
     * BindException 공통 처리 메서드
     * @param e BindException
     * @return 400 오류 메세지
     */
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(BindException.class)
    public ApiResponse<?> bindException(BindException e) {
        return ApiResponse.ERROR(
                e.getMessage(),
                HttpStatus.BAD_REQUEST
        );
    }

    /**
     * IllegalArgumentException 공통 처리 메서드
     * @param e IllegalArgumentException
     * @return 400 오류 메세지
     */
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(IllegalArgumentException.class)
    public ApiResponse<?> illegalArgumentException(IllegalArgumentException e) {
        return ApiResponse.ERROR(
                e.getMessage(),
                HttpStatus.BAD_REQUEST
        );
    }

    /**
     * NoSuchElementException 공통 처리 메서드
     * @param e NoSuchElementException
     * @return 404 오류 메세지
     */
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(NoSuchElementException.class)
    public ApiResponse<?> noSuchElementException(NoSuchElementException e) {
        return ApiResponse.ERROR(
                e.getMessage(),
                HttpStatus.BAD_REQUEST
        );
    }

    /**
     * Custom Exception 공통 처리 메서드
     * @param e CustomException
     * @return
     */
    @ExceptionHandler(CustomException.class)
    public ApiResponse<?> customException(CustomException e){
        return ApiResponse.ERROR(
                e.getErrorCode().getMessage(),
                e.getErrorCode().getStatus()
        );
    }



}
