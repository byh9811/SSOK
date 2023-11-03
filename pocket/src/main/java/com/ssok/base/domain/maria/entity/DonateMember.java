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
public class DonateMember extends BaseEntity {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "donate_member_seq")
    private Long donateMemberSeq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "donate_seq")
    private Donate donate;

    private Long memberSeq;

    // 누적 기부 금액
    private Long totalDonateAmt;

    @Builder
    public DonateMember(Long donateMemberSeq, Donate donate, Long memberSeq, Long totalDonateAmt) {
        this.donateMemberSeq = donateMemberSeq;
        this.donate = donate;
        this.memberSeq = memberSeq;
        this.totalDonateAmt = totalDonateAmt;
    }
}
