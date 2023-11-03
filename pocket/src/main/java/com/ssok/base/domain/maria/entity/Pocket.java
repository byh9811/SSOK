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

    private Long pocketSaving;

    private Long pocketTotalDonate;

    private Long pocketTotalPoint;

    @Builder
    public Pocket(Long memberSeq, Long pocketSaving, Long pocketTotalDonate, Long pocketTotalPoint) {
        this.memberSeq = memberSeq;
        this.pocketSaving = pocketSaving;
        this.pocketTotalDonate = pocketTotalDonate;
        this.pocketTotalPoint = pocketTotalPoint;
    }
}
