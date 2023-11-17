package com.ssok.receipt.domain.api.dto.response;

import com.ssok.receipt.domain.api.dto.inner.InnerPaymentItem;
import com.ssok.receipt.domain.mongo.document.ReceiptDetailDocument;
import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.List;

@Builder
public record ReceiptDetailQueryResponse(
        String cardCompany,
        String cardNumberFirstSection,
        String cardType,
        String approvedNum,
        String shopName,
        Long payAmt,
        LocalDateTime approvedDate,
        String transactionType,
        List<InnerPaymentItem> paymentItemList
) {

    public static ReceiptDetailQueryResponse from(ReceiptDetailDocument receiptDetailDocument) {
        return ReceiptDetailQueryResponse.builder()
                .cardCompany(receiptDetailDocument.getCardCompany())
                .cardNumberFirstSection(receiptDetailDocument.getCardNumberFirstSection())
                .cardType(receiptDetailDocument.getCardType())
                .approvedNum(receiptDetailDocument.getApprovedNum())
                .shopName(receiptDetailDocument.getShopName())
                .payAmt(receiptDetailDocument.getPayAmt())
                .approvedDate(receiptDetailDocument.getApprovedDate())
                .transactionType(receiptDetailDocument.getTransactionType())
                .paymentItemList(receiptDetailDocument.getPaymentItemList())
                .build();
    }

}