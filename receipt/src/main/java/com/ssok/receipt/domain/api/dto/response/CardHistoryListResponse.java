package com.ssok.receipt.domain.api.dto.response;

import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import com.ssok.receipt.global.openfeign.mydata.card.dto.inner.CardTransactionList;
import lombok.*;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

@Builder
public record CardHistoryListResponse (
        String receiptDetailDocumentId,
        String shopName,
        Long payAmt,
        LocalDateTime approvedDate,
        String transactionType
) {

    public static CardHistoryListResponse from(String receiptDetailDocumentId, CardTransactionList cardTransactionList) {
        return CardHistoryListResponse.builder()
                .receiptDetailDocumentId(receiptDetailDocumentId)
                .shopName(cardTransactionList.getMerchantName())
                .payAmt(cardTransactionList.getApprovedAmt())
                .approvedDate(cardTransactionList.getApprovedDtime())
                .transactionType(cardTransactionList.getPayType())
                .build();
    }

}
