package com.ssok.base.domain.service.dto;

import com.ssok.base.domain.maria.entity.Donate;
import lombok.Builder;
import lombok.Data;

@Data
public class DonatePocketHistoryDto {
    private Long memberSeq;
    private Donate donate;
    private String pocketHistoryType;
    private Long pocketHistoryTransAmt;

    @Builder
    public DonatePocketHistoryDto(Long memberSeq, Donate donate, String pocketHistoryType, Long pocketHistoryTransAmt) {
        this.memberSeq = memberSeq;
        this.donate = donate;
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
    }
}
