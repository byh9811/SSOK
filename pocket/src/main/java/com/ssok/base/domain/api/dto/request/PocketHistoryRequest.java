package com.ssok.base.domain.api.dto.request;

import com.ssok.base.domain.service.dto.PocketHistoryAppDto;
import com.ssok.base.domain.service.dto.PocketHistoryDto;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PocketHistoryRequest {
    // 구분
    private String pocketHistoryType;
    // 금액
    private Long pocketHistoryTransAmt;


    @Builder
    public PocketHistoryRequest(String pocketHistoryType, Long pocketHistoryTransAmt) {
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
    }

    public PocketHistoryAppDto toDto(String memberUuid){
        return PocketHistoryAppDto.builder()
                .memberUuid(memberUuid)
                .pocketHistoryType(this.pocketHistoryType)
                .pocketHistoryTransAmt(this.pocketHistoryTransAmt)
                .build();
    }
}
