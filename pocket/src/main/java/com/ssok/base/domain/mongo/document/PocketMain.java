package com.ssok.base.domain.mongo.document;

import com.ssok.base.domain.maria.entity.Pocket;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
//import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "pocket_main")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class PocketMain {
    @Id
    private Long memberSeq;

    private Long pocketSaving;
    // 레벨 , 경험치

    // 누적 기부 금액
    private Long pocketTotalDonate;

    // 누적 탄소중립포인트
    private Long pocketTotalPoint;

    // 누적 잔금 저축 금액
    private Long pocketTotalChange;

    private Boolean pocketIsChangeSaving;

    private LocalDateTime createDate;

    private LocalDateTime modifyDate;

    @Builder
    public PocketMain(Long memberSeq, Long pocketSaving, Long pocketTotalDonate, Long pocketTotalPoint, Long pocketTotalChange, Boolean pocketIsChangeSaving, LocalDateTime createDate, LocalDateTime modifyDate) {
        this.memberSeq = memberSeq;
        this.pocketSaving = pocketSaving;
        this.pocketTotalDonate = pocketTotalDonate;
        this.pocketTotalPoint = pocketTotalPoint;
        this.pocketTotalChange = pocketTotalChange;
        this.pocketIsChangeSaving = pocketIsChangeSaving;
        this.createDate = createDate;
        this.modifyDate = modifyDate;
    }

    static public PocketMain fromPocket(Pocket pocket){
        return PocketMain.builder()
                .memberSeq(pocket.getMemberSeq())
                .pocketSaving(pocket.getPocketSaving())
                .pocketTotalDonate(pocket.getPocketTotalDonate())
                .pocketTotalChange(pocket.getPocketTotalChange())
                .pocketTotalPoint(pocket.getPocketTotalPoint())
                .pocketIsChangeSaving(pocket.getPocketIsChangeSaving())
                .createDate(pocket.getCreateDate())
                .modifyDate(pocket.getModifyDate())
                .build();
    }

    public void updatePocketMain(Pocket pocket) {
        this.pocketSaving = pocket.getPocketSaving();
        this.pocketTotalDonate = pocket.getPocketTotalDonate();
        this.pocketTotalPoint = pocket.getPocketTotalPoint();
        this.pocketTotalChange = pocket.getPocketTotalChange();
        this.pocketIsChangeSaving = pocket.getPocketIsChangeSaving();
        this.createDate = pocket.getCreateDate();
        this.modifyDate = pocket.getModifyDate();
    }
}
