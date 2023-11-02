package com.ssok.namecard.domain.exception;

import com.ssok.namecard.global.exception.BaseException;
import com.ssok.namecard.global.exception.ErrorCode;

public class NamecardException extends BaseException {

    public NamecardException(ErrorCode errorCode) {
        super(errorCode);
    }
}
