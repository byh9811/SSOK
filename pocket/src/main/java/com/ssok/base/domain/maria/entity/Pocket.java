package com.ssok.base.domain.maria.entity;


import com.ssok.base.global.entity.BaseEntity;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;



@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Pocket extends BaseEntity {
    @Id
    @Column(name = "member_UUID")
    private Long memberUUID;

    private Long pocketSaving;

    private Long pocketTotalDonate;

    private Long pocketTotalPoint;

    @Builder
    public Pocket(Long memberUUID, Long pocketSaving, Long pocketTotalDonate, Long pocketTotalPoint) {
        this.memberUUID = memberUUID;
        this.pocketSaving = pocketSaving;
        this.pocketTotalDonate = pocketTotalDonate;
        this.pocketTotalPoint = pocketTotalPoint;
    }
}
