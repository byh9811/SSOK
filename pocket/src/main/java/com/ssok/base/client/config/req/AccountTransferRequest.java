package com.ssok.base.client.config.req;

import com.ssok.base.domain.service.dto.PocketHistoryDto;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AccountTransferRequest {
    private Long memberSeq;

    private Long amt;

    @Builder
    public AccountTransferRequest(Long memberSeq, Long amt) {
        this.memberSeq = memberSeq;
        this.amt = amt;
    }

    static public AccountTransferRequest fromHistory(PocketHistoryDto dto){
        return AccountTransferRequest.builder()
                .memberSeq(dto.getMemberSeq())
                .amt(dto.getPocketHistoryTransAmt())
                .build();
    }
}
