package com.ssok.base.domain.api.dto.response;

import com.ssok.base.domain.maria.entity.Pocket;
import lombok.Builder;
import lombok.Data;

@Data
public class PocketResponse {
    // 누적 금액
    private Long pocketSaving;

    // 누적 기부 금액
    private Long pocketTotalDonate;

    // 누적 탄소중립포인트
    private Long pocketTotalPoint;

    @Builder
    public PocketResponse(Long pocketSaving, Long pocketTotalDonate, Long pocketTotalPoint) {
        this.pocketSaving = pocketSaving;
        this.pocketTotalDonate = pocketTotalDonate;
        this.pocketTotalPoint = pocketTotalPoint;
    }

    public static PocketResponse of(Pocket pocket){
        return PocketResponse.builder()
                .pocketSaving(pocket.getPocketSaving())
                .pocketTotalDonate(pocket.getPocketTotalDonate())
                .pocketTotalPoint(pocket.getPocketTotalPoint())
                .build();
    }
}
