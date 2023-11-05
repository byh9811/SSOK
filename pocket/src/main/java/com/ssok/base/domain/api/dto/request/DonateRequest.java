package com.ssok.base.domain.api.dto.request;

import com.ssok.base.domain.service.dto.DonateDto;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DonateRequest {
    // 기부 금액
    private Long donateAmt;
    // 기부 식별자
    private Long donateSeq;

    @Builder
    public DonateRequest(Long donateAmt, Long donateSeq) {
        this.donateAmt = donateAmt;
        this.donateSeq = donateSeq;
    }

    public DonateDto toDto(String memberUuid) {
        return DonateDto.builder()
                .memberUuid(memberUuid)
                .donateAmt(this.donateAmt)
                .donateSeq(this.donateSeq)
                .build();
    }
}
