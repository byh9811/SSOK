package com.ssok.receipt.domain.service.dto;

import com.ssok.receipt.domain.api.dto.request.ReceiptCreateRequest;

public record ReceiptCreateDto(String nickname, int age) {

    public static ReceiptCreateDto fromRequest(ReceiptCreateRequest request) {
        return new ReceiptCreateDto(request.nickname(), request.age());
    }

}