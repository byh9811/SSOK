package com.ssok.base.domain.service.dto;

import lombok.Builder;
import lombok.Data;

@Data
public class PocketHistoryDto {
    private String memberUuid;
    private Long receiptSeq;
    private String pocketHistoryType;
    private Long pocketHistoryTransAmt;

    @Builder
    public PocketHistoryDto(String memberUuid,Long receiptSeq, String pocketHistoryType, Long pocketHistoryTransAmt) {
        this.memberUuid = memberUuid;
        this.receiptSeq = receiptSeq;
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
    }
}
