package com.ssok.base.domain.mongo.document;

import com.ssok.base.domain.maria.entity.PocketHistory;
import com.ssok.base.domain.maria.entity.PocketHistoryType;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "pocket_detail")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class PocketDetail {
    @Id
    private Long pocketHistorySeq;

    private Long memberSeq;

    private Long pocketHistoryTransAmt;

    private Long pocketHistoryResultAmt;

    private String pocketHistoryTitle;

    private PocketHistoryType pocketHistoryType;

    private String receiptDocumentId;

    private LocalDateTime createDate;

    private LocalDateTime modifyDate;

    @Builder
    public PocketDetail(Long pocketHistorySeq, Long memberSeq, Long pocketHistoryTransAmt, Long pocketHistoryResultAmt, String pocketHistoryTitle, PocketHistoryType pocketHistoryType, String receiptDocumentId, LocalDateTime createDate, LocalDateTime modifyDate) {
        this.pocketHistorySeq = pocketHistorySeq;
        this.memberSeq = memberSeq;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
        this.pocketHistoryResultAmt = pocketHistoryResultAmt;
        this.pocketHistoryTitle = pocketHistoryTitle;
        this.pocketHistoryType = pocketHistoryType;
        this.receiptDocumentId = receiptDocumentId;
        this.createDate = createDate;
        this.modifyDate = modifyDate;
    }

    static public PocketDetail fromPocketHistory(PocketHistory pocketHistory, String receiptDocumentId){
        return PocketDetail.builder()
                .pocketHistorySeq(pocketHistory.getPocketHistorySeq())
                .memberSeq(pocketHistory.getMemberSeq())
                .pocketHistoryTransAmt(pocketHistory.getPocketHistoryTransAmt())
                .pocketHistoryResultAmt(pocketHistory.getPocketHistoryResultAmt())
                .pocketHistoryTitle(pocketHistory.getPocketHistoryTitle())
                .pocketHistoryType(pocketHistory.getPocketHistoryType())
                .receiptDocumentId(receiptDocumentId)
                .createDate(pocketHistory.getCreateDate())
                .modifyDate(pocketHistory.getModifyDate())
                .build();
    }
}
