package com.ssok.base.domain.api.dto.request;

import com.ssok.base.domain.service.dto.PocketHistoryAppDto;
import com.ssok.base.domain.service.dto.PocketHistoryDto;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PocketHistoryRequest {
    private Long receiptSeq;
    // 구분
    private String pocketHistoryType;
    // 금액
    private Long pocketHistoryTransAmt;


    @Builder
    public PocketHistoryRequest(Long receiptSeq, String pocketHistoryType, Long pocketHistoryTransAmt) {
        this.receiptSeq = receiptSeq;
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
    }

    public PocketHistoryAppDto toDto(String memberUuid){
        return PocketHistoryAppDto.builder()
                .memberUuid(memberUuid)
                .receiptSeq(this.receiptSeq)
                .pocketHistoryType(this.pocketHistoryType)
                .pocketHistoryTransAmt(this.pocketHistoryTransAmt)
                .build();
    }
}
