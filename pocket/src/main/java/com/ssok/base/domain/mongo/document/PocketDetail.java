package com.ssok.base.domain.mongo.document;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.persistence.Id;
import java.time.LocalDateTime;

@Document(collection = "pocket_detail")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class PocketDetail {
    @Id
    private Long pocketHistorySeq;

    private Long pocketHistoryTransAmt;

    private Long pocketHistoryResultAmt;

    private String pocketHistoryTitle;

    private Long receiptSeq;

    private LocalDateTime createDate;

    private LocalDateTime modifyDate;

    @Builder
    public PocketDetail(Long pocketHistorySeq, Long pocketHistoryTransAmt, Long pocketHistoryResultAmt, String pocketHistoryTitle, Long receiptSeq, LocalDateTime createDate, LocalDateTime modifyDate) {
        this.pocketHistorySeq = pocketHistorySeq;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
        this.pocketHistoryResultAmt = pocketHistoryResultAmt;
        this.pocketHistoryTitle = pocketHistoryTitle;
        this.receiptSeq = receiptSeq;
        this.createDate = createDate;
        this.modifyDate = modifyDate;
    }
}
