package com.ssok.base.domain.maria.entity;

import com.ssok.base.global.entity.BaseEntity;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

/**
 * 기부자 엔티티 / pk : 기부자 식별키
 *
 * @author 홍진식
 */
@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
//@IdClass(DonateMemberKey.class)
public class DonateMember extends BaseEntity {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "donate_member_seq")
    private Long donateMemberSeq;
//    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "donate_seq")
    private Donate donate;
//    @Id
    private Long memberSeq;

    // 누적 기부 금액
    private Long totalDonateAmt;

    @Builder
    public DonateMember(Donate donate, Long memberSeq, Long totalDonateAmt) {
        this.donate = donate;
        this.memberSeq = memberSeq;
        this.totalDonateAmt = totalDonateAmt;
    }

    public void updateTotalDonateAmt(Long donateAmt) {
        this.totalDonateAmt += donateAmt;
    }
}
