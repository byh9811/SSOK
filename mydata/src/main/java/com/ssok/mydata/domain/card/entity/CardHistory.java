package com.ssok.mydata.domain.card.entity;

import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class CardHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JoinColumn(name = "card_id")
    @ManyToOne(fetch = FetchType.LAZY)
    private Card card;

    private String approvedNum;

    private LocalDateTime approvedDtime;

    private String status;

    private String payType;

    private LocalDateTime transDtime;

    private String merchantName;

    private String merchantRegno;

    private Long approvedAmt;

    private Long modifiedAmt;

    private Integer totalInstallCnt;

}
