package com.ssok.base.domain.maria.entity;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import java.io.Serializable;

@Data
@NoArgsConstructor
public class CarbonHistoryKey implements Serializable {
    private Long receiptSeq;
    private PocketHistory pocketHistory;

    @Builder
    public CarbonHistoryKey(Long receiptSeq, PocketHistory pocketHistory) {
        this.receiptSeq = receiptSeq;
        this.pocketHistory = pocketHistory;
    }
}
