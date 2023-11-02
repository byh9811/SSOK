package com.ssok.receipt.domain.api.dto.response;

import com.ssok.receipt.domain.mongo.document.Receipt;
import lombok.Builder;

@Builder
public record ReceiptCreateResponse(String nickname, int age) {

    public static ReceiptCreateResponse from(Receipt receipt) {
        return new ReceiptCreateResponse(receipt.getName(), receipt.getAge());
    }

}