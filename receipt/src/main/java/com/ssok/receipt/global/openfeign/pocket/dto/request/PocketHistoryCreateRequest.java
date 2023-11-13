package com.ssok.receipt.global.openfeign.pocket.dto.request;

import lombok.Builder;

@Builder
public record PocketHistoryCreateRequest(
        Long memberSeq,
        String receiptDocumentId,
        String pocketHistoryType,
        Long pocketHistoryTransAmt

) {
}
