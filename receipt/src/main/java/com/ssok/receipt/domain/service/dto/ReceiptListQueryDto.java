package com.ssok.receipt.domain.service.dto;

import com.ssok.receipt.domain.api.dto.request.ReceiptCreateRequest;
import com.ssok.receipt.domain.api.dto.request.ReceiptQueryRequest;

public record ReceiptListQueryDto(int year, int month) {

    public static ReceiptListQueryDto fromRequest(ReceiptQueryRequest request) {
        return new ReceiptListQueryDto(request.year(), request.month());
    }

}