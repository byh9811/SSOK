package com.ssok.base.domain.maria.entity;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@IdClass(CarbonHistory.class)
public class CarbonHistory implements Serializable {
    @Id
    private Long receiptSeq;
    @Id @OneToOne
    @JoinColumn(name = "pocket_history_seq")
    PocketHistory pocketHistory;

    @Builder
    public CarbonHistory(Long receiptSeq, PocketHistory pocketHistory) {
        this.receiptSeq = receiptSeq;
        this.pocketHistory = pocketHistory;
    }
}
