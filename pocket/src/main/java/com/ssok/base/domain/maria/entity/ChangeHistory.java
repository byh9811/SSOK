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
public class ChangeHistory{
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "change_history_seq")
    private Long changeHistorySeq;

    private String receiptDocumentId;

    @OneToOne
    @JoinColumn(name = "pocket_history_seq")
    private PocketHistory pocketHistory;

    @Builder
    public ChangeHistory(String receiptDocumentId, PocketHistory pocketHistory) {
        this.receiptDocumentId = receiptDocumentId;
        this.pocketHistory = pocketHistory;
    }
}
