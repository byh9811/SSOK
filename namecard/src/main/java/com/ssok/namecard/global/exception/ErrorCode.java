package com.ssok.namecard.global.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {


    /** Maria */

    /* 명함 예외 */
    NAMECARD_NOT_FOUND("NAMECARD_01", HttpStatus.NOT_FOUND, "존재하지 않는 명함입니다."),
    NAMECARD_BAD_REQUEST("NAMECARD_02", HttpStatus.BAD_REQUEST, "이미지는 필수입니다."),
    GCS_EXCEPTION("NAMECARD_03", HttpStatus.BAD_REQUEST, "GCS 업로드시 오류가 발생했습니다."),


    /* 명함교환 예외 */
    EXCHANGE_DUPLICATED("EXCHANGE_01", HttpStatus.NOT_ACCEPTABLE, "교환을 한 상대입니다."),
    EXCHANGE_NOT_FOUND("EXCHANGE_02", HttpStatus.NOT_FOUND, "해당 명함 교환을 찾을 수 없습니다."),
    EXCHANGE_BAD_REQUEST("EXCHANGE_03", HttpStatus.NOT_FOUND, "잘못된 명함 교환입니다."),

    /** Mongo */
    MONGO_NAMECARD_NOT_FOUND("NAMECARD_MONGO_01", HttpStatus.NOT_FOUND, "존재하지 않는 명함입니다."),
    MONGO_MEMO_NOT_FOUND("MEMO_MONGO_01", HttpStatus.NOT_FOUND, "존재하지 않는 명함 메모입니다."),
    ;





    private final String code;
    private final HttpStatus httpStatus;
    private final String message;
}
