package com.ssok.base.domain.api.dto.response;

import com.ssok.base.domain.maria.entity.Pocket;
import com.ssok.base.domain.mongo.document.PocketMain;
import lombok.Builder;
import lombok.Data;
import org.eclipse.jdt.internal.compiler.ast.Block;

@Data
public class PocketResponse {
    // 누적 금액
    private Long pocketSaving;

    // 누적 기부 금액
    private Long pocketTotalDonate;

    // 누적 탄소중립포인트
    private Long pocketTotalPoint;

    // 누적 잔금 저축 금액
    private Long pocketTotalChange;

    // 잔금 저금 여부
    private Boolean pocketIsChangeSaving;

    @Builder
    public PocketResponse(Long pocketSaving, Long pocketTotalDonate, Long pocketTotalPoint, Long pocketTotalChange, Boolean pocketIsChangeSaving) {
        this.pocketSaving = pocketSaving;
        this.pocketTotalDonate = pocketTotalDonate;
        this.pocketTotalPoint = pocketTotalPoint;
        this.pocketTotalChange = pocketTotalChange;
        this.pocketIsChangeSaving = pocketIsChangeSaving;
    }

    public static PocketResponse of(Pocket pocket){
        return PocketResponse.builder()
                .pocketSaving(pocket.getPocketSaving())
                .pocketTotalDonate(pocket.getPocketTotalDonate())
                .pocketTotalPoint(pocket.getPocketTotalPoint())
                .pocketTotalChange(pocket.getPocketTotalChange())
                .pocketIsChangeSaving(pocket.getPocketIsChangeSaving())
                .build();
    }

    public static PocketResponse fromPocketMain(PocketMain pocketMain){
        return PocketResponse.builder()
                .pocketSaving(pocketMain.getPocketSaving())
                .pocketTotalDonate(pocketMain.getPocketTotalDonate())
                .pocketTotalPoint(pocketMain.getPocketTotalPoint())
                .pocketTotalChange(pocketMain.getPocketTotalChange())
                .pocketIsChangeSaving(pocketMain.getPocketIsChangeSaving())
                .build();
    }
}
