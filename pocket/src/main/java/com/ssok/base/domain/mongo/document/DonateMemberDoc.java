package com.ssok.base.domain.mongo.document;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.persistence.Id;

@Document(collection = "donate_member")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class DonateMemberDoc {
    @Id
    private String _id;

    private Long donateSeq;
    //    @Id
    private Long memberSeq;

    // 누적 기부 금액
    private Long totalDonateAmt;

    @Builder
    public DonateMemberDoc(Long donateSeq, Long memberSeq, Long totalDonateAmt) {
        this.donateSeq = donateSeq;
        this.memberSeq = memberSeq;
        this.totalDonateAmt = totalDonateAmt;
    }

    public void updateAmt(Long donateAmt) {
        this.totalDonateAmt += donateAmt;
    }
}
