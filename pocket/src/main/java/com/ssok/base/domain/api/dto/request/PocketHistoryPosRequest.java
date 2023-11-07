package com.ssok.base.domain.api.dto.request;

import com.ssok.base.domain.service.dto.PocketHistoryDto;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PocketHistoryPosRequest {

    private Long memberSeq;

    private Long receiptSeq;
    // 구분
    private String pocketHistoryType;
    // 금액
    private Long pocketHistoryTransAmt;

    @Builder
    public PocketHistoryPosRequest(Long memberSeq, Long receiptSeq, String pocketHistoryType, Long pocketHistoryTransAmt) {
        this.memberSeq = memberSeq;
        this.receiptSeq = receiptSeq;
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
    }

    public PocketHistoryDto toDto(){
        return PocketHistoryDto.builder()
                .memberSeq(this.memberSeq)
                .receiptSeq(this.receiptSeq)
                .pocketHistoryType(this.pocketHistoryType)
                .pocketHistoryTransAmt(this.pocketHistoryTransAmt)
                .build();
    }
}
