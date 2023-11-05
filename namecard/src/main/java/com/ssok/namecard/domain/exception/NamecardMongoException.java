package com.ssok.namecard.domain.exception;

import com.ssok.namecard.global.exception.BaseException;
import com.ssok.namecard.global.exception.ErrorCode;

public class NamecardMongoException extends BaseException {


    public NamecardMongoException(ErrorCode errorCode) {
        super(errorCode);
    }
}
