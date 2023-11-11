package com.ssok.namecard.domain.exception;

import com.ssok.namecard.global.exception.BaseException;
import com.ssok.namecard.global.exception.ErrorCode;

public class MemoDocException extends BaseException {

    public MemoDocException(ErrorCode errorCode) {
        super(errorCode);
    }
}
