package com.ssok.namecard.domain.exception;

import com.ssok.namecard.global.exception.BaseException;
import com.ssok.namecard.global.exception.ErrorCode;

public class NamecardDocException extends BaseException {


    public NamecardDocException(ErrorCode errorCode) {
        super(errorCode);
    }
}
