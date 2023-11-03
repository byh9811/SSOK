package com.ssok.namecard.domain.exception;

import com.ssok.namecard.global.exception.BaseException;
import com.ssok.namecard.global.exception.ErrorCode;

public class ExchangeException extends BaseException {

    public ExchangeException(ErrorCode errorCode) {
        super(errorCode);
    }
}
