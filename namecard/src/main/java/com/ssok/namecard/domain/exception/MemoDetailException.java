package com.ssok.namecard.domain.exception;

import com.ssok.namecard.global.exception.BaseException;
import com.ssok.namecard.global.exception.ErrorCode;

public class MemoDetailException extends BaseException {

    public MemoDetailException(ErrorCode errorCode) {
        super(errorCode);
    }
}
