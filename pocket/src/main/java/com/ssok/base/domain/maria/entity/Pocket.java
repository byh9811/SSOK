package com.ssok.base.domain.maria.entity;


import com.ssok.base.global.entity.BaseEntity;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;


/**
 * 포켓 엔티티 / PK : 멤버 식별자
 *
 * @author 홍진식
 */

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Pocket extends BaseEntity {
    @Id
    @Column(name = "member_seq")
    private Long memberSeq;

    //  저축 금액
    private Long pocketSaving;

    // 누적 기부 금액
    private Long pocketTotalDonate;

    // 누적 탄소중립포인트
    private Long pocketTotalPoint;

    // 누적 잔금 저축 금액
    private Long pocketTotalChange;

    @Builder
    public Pocket(Long memberSeq, Long pocketSaving, Long pocketTotalDonate, Long pocketTotalPoint, Long pocketTotalChange) {
        this.memberSeq = memberSeq;
        this.pocketSaving = pocketSaving;
        this.pocketTotalDonate = pocketTotalDonate;
        this.pocketTotalPoint = pocketTotalPoint;
        this.pocketTotalChange = pocketTotalChange;
    }

    public void transferChange(Long amt) {
        this.pocketSaving += amt;
        this.pocketTotalChange += amt;
    }

    public void transferCarbon(Long amt) {
        this.pocketSaving += amt;
        this.pocketTotalPoint += amt;
    }

    public void transferDonation(Long amt) {
        this.pocketSaving -= amt;
        this.pocketTotalDonate += amt;
    }

    public void transferWithdrawal(Long amt) {
        this.pocketSaving -= amt;
    }
}
