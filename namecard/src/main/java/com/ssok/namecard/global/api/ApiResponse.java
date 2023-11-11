package com.ssok.namecard.global.api;


import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.springframework.http.HttpStatus;

public class  ApiResponse<T> {
    private final boolean success;
    private final T response;
    private final ApiError error;
    private ApiResponse(boolean success, T response, ApiError error) {
        this.success = success;
        this.response = response;
        this.error = error;
    }

    //정상일떄
    public static <T> ApiResponse<T> OK(T response) {
        return new ApiResponse<>(true, response, null);
    }
    public static ApiResponse<?> ERROR(String code, HttpStatus status, String message) {
        return new ApiResponse<>(false, null, new ApiError(code, message, status));
    }

    //성공 여부
    public boolean isSuccess() {
        return success;
    }
    //에러
    public ApiError getError() {
        return error;
    }
    //응답값
    public T getResponse() {
        return response;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("success", success)
                .append("response", response)
                .append("error", error)
                .toString();
    }

}