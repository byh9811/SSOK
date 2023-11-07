package com.ssok.base.domain.api.dto.response;

import com.ssok.base.domain.maria.entity.PocketHistoryType;
import com.ssok.base.domain.mongo.document.PocketDetail;
import com.ssok.base.domain.mongo.document.PocketMain;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
@NoArgsConstructor
public class PocketDetailResponse {
    private Long pocketHistorySeq;
    private PocketHistoryType pocketHistoryType;
    // 이동 금액
    private Long pocketHistoryTransAmt;
    // 남은 금액
    private Long pocketHistoryResultAmt;
    private Long receiptSeq;
    private String pocketHistoryTitle;
    private String createTime;

    @Builder
    public PocketDetailResponse(Long pocketHistorySeq, PocketHistoryType pocketHistoryType, Long pocketHistoryTransAmt, Long pocketHistoryResultAmt, Long receiptSeq, String pocketHistoryTitle, LocalDateTime createTime) {
        this.pocketHistorySeq = pocketHistorySeq;
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
        this.pocketHistoryResultAmt = pocketHistoryResultAmt;
        this.receiptSeq = receiptSeq;
        this.pocketHistoryTitle = pocketHistoryTitle;
        this.createTime = createTime.format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm"));
    }

    static public PocketDetailResponse fromPocketDetail(PocketDetail pocketDetail){
        return PocketDetailResponse.builder()
                .pocketHistorySeq(pocketDetail.getPocketHistorySeq())
                .pocketHistoryType(pocketDetail.getPocketHistoryType())
                .pocketHistoryTransAmt(pocketDetail.getPocketHistoryTransAmt())
                .pocketHistoryResultAmt(pocketDetail.getPocketHistoryResultAmt())
                .receiptSeq(pocketDetail.getReceiptSeq())
                .pocketHistoryTitle(pocketDetail.getPocketHistoryTitle())
                .createTime(pocketDetail.getCreateDate())
                .build();
    }
}
