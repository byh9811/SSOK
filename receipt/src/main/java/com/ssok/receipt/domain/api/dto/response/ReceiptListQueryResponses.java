package com.ssok.receipt.domain.api.dto.response;

import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.List;

@Builder
public record ReceiptListQueryResponses(
        Integer totalHistory,
        Long totalPay,
        List<ReceiptListQueryResponse> receiptListQueryResponses
) {

}