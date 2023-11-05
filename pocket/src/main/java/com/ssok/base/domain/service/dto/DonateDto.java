package com.ssok.base.domain.service.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DonateDto {
    private String memberUuid;
    private Long donateAmt;
    private Long donateSeq;

    @Builder
    public DonateDto(String memberUuid, Long donateAmt, Long donateSeq) {
        this.memberUuid = memberUuid;
        this.donateAmt = donateAmt;
        this.donateSeq = donateSeq;
    }
}
