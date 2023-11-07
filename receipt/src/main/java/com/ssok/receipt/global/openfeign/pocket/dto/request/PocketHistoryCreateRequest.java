package com.ssok.receipt.global.openfeign.pocket.dto.request;

import lombok.Builder;

@Builder
public record PocketHistoryCreateRequest(
        Long memberSeq,
        Long receiptSeq,
        String pocketHistoryType,
        Long pocketHistoryTransAmt

) {
}
