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
@IdClass(ChangeHistory.class)
public class ChangeHistory implements Serializable {
    @Id
    private Long receiptSeq;
    @Id @OneToOne
    @JoinColumn(name = "pocket_history_seq")
    private PocketHistory pocketHistory;

    @Builder
    public ChangeHistory(Long receiptSeq, PocketHistory pocketHistory) {
        this.receiptSeq = receiptSeq;
        this.pocketHistory = pocketHistory;
    }
}
