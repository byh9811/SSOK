package com.ssok.base.domain.maria.entity;

import com.ssok.base.global.entity.BaseEntity;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

/**
 * 포켓 내역 엔티티 / pk : 내역 식별키
 *
 * @author 홍진식
 */
@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class PocketHistory extends BaseEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "pocket_history_seq")
    private Long pocketHistorySeq;
    // 멤버 식별자
    private Long memberSeq;

    @Enumerated(EnumType.STRING)
    private PocketHistoryType pocketHistoryType;

    // 이동 금액
    private Long pocketHistoryTransAmt;
    // 남은 금액
    private Long pocketHistoryResultAmt;
    // 내역 제목
    private String pocketHistoryTitle;

    @Builder
    public PocketHistory(Long pocketHistorySeq, Long memberSeq, PocketHistoryType pocketHistoryType, Long pocketHistoryTransAmt, Long pocketHistoryResultAmt, String pocketHistoryTitle) {
        this.pocketHistorySeq = pocketHistorySeq;
        this.memberSeq = memberSeq;
        this.pocketHistoryType = pocketHistoryType;
        this.pocketHistoryTransAmt = pocketHistoryTransAmt;
        this.pocketHistoryResultAmt = pocketHistoryResultAmt;
        this.pocketHistoryTitle = pocketHistoryTitle;
    }
}
