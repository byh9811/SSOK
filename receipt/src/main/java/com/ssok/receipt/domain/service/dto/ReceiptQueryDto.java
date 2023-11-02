package com.ssok.receipt.domain.service.dto;

import com.ssok.receipt.domain.api.dto.request.ReceiptCreateRequest;

public record ReceiptQueryDto(String nickname, int age) {

    public static ReceiptQueryDto fromRequest(ReceiptCreateRequest request) {
        return new ReceiptQueryDto(request.nickname(), request.age());
    }

}