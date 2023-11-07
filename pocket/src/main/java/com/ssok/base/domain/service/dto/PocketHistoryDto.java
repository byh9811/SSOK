package com.ssok.base.domain.service.dto;

import lombok.Builder;
import lombok.Data;

@Data
public class PocketHistoryDto {
    private Long memberSeq;
    private Long receiptSeq;
    private String pocketHistoryType;
    private Long pocketHistoryTransAmt;

    @Builder
    public PocketHistoryDto(Long memberSeq,Long receiptSeq, String pocketHistoryType, Long pocketHistoryTransAmt) {
        this.memberSeq = memberSeq;
        this.receiptSeq = receiptSeq;
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
    }

    static public PocketHistoryDto fromPocketHistoryAppDto(PocketHistoryAppDto pocketHistoryAppDto, Long memberSeq){
        return PocketHistoryDto.builder()
                .memberSeq(memberSeq)
                .receiptSeq(pocketHistoryAppDto.getReceiptSeq())
                .pocketHistoryType(pocketHistoryAppDto.getPocketHistoryType())
                .pocketHistoryTransAmt(pocketHistoryAppDto.getPocketHistoryTransAmt())
                .build();
    }
}
