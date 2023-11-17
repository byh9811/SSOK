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
    private String receiptDocumentId;
    private PocketHistory pocketHistory;

    @Builder
    public CarbonHistoryKey(String receiptDocumentId, PocketHistory pocketHistory) {
        this.receiptDocumentId = receiptDocumentId;
        this.pocketHistory = pocketHistory;
    }
}
