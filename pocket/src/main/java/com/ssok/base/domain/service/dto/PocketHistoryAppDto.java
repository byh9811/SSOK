package com.ssok.base.domain.service.dto;

import lombok.Builder;
import lombok.Data;

@Data
public class PocketHistoryAppDto {
    private String memberUuid;
    private String pocketHistoryType;
    private Long pocketHistoryTransAmt;

    @Builder
    public PocketHistoryAppDto(String memberUuid, String pocketHistoryType, Long pocketHistoryTransAmt) {
        this.memberUuid = memberUuid;
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
    }
}
