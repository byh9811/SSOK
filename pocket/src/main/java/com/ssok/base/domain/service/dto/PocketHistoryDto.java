package com.ssok.base.domain.service.dto;

import lombok.Builder;
import lombok.Data;

@Data
public class PocketHistoryDto {
    private Long memberSeq;
    private String receiptDocumentId;
    private String pocketHistoryType;
    private Long pocketHistoryTransAmt;

    @Builder
    public PocketHistoryDto(Long memberSeq,String receiptDocumentId, String pocketHistoryType, Long pocketHistoryTransAmt) {
        this.memberSeq = memberSeq;
        this.receiptDocumentId = receiptDocumentId;
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
    }

    // Receipt 없는 버전
    static public PocketHistoryDto fromPocketHistoryAppDto(PocketHistoryAppDto pocketHistoryAppDto, Long memberSeq){
        return PocketHistoryDto.builder()
                .memberSeq(memberSeq)
                .receiptDocumentId(null)
                .pocketHistoryType(pocketHistoryAppDto.getPocketHistoryType())
                .pocketHistoryTransAmt(pocketHistoryAppDto.getPocketHistoryTransAmt())
                .build();
    }
}
