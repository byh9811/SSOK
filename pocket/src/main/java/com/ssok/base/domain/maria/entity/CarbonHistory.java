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
//@IdClass(CarbonHistoryKey.class)
public class CarbonHistory {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "carbon_history_seq")
    private Long carbonHistorySeq;

    private Long receiptSeq;

    @OneToOne
    @JoinColumn(name = "pocket_history_seq")
    private PocketHistory pocketHistory;

    @Builder
    public CarbonHistory(Long receiptSeq, PocketHistory pocketHistory) {
        this.receiptSeq = receiptSeq;
        this.pocketHistory = pocketHistory;
    }
}
