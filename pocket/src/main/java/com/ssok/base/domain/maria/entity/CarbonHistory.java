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

    private String receiptDocumentId;

    @OneToOne
    @JoinColumn(name = "pocket_history_seq")
    private PocketHistory pocketHistory;

    @Builder
    public CarbonHistory(String receiptDocumentId, PocketHistory pocketHistory) {
        this.receiptDocumentId = receiptDocumentId;
        this.pocketHistory = pocketHistory;
    }
}
