package com.ssok.receipt.domain.api.dto.response;

import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record ReceiptListQueryResponse(
        String receiptDetailDocumentId,
        String shopName,
        Long payAmt,
        LocalDateTime approvedDate,
        String transactionType
) {

    public static ReceiptListQueryResponse from(ReceiptListDocument receiptListDocument) {
        return ReceiptListQueryResponse.builder()
                .receiptDetailDocumentId(receiptListDocument.getReceiptDetailDocumentSeq())
                .shopName(receiptListDocument.getShopName())
                .payAmt(receiptListDocument.getPayAmt())
                .approvedDate(receiptListDocument.getApprovedDate())
                .transactionType(receiptListDocument.getTransactionType())
                .build();
    }

}