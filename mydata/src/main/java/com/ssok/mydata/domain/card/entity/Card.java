package com.ssok.mydata.domain.card.entity;

import lombok.*;

import javax.persistence.*;
import java.sql.Date;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Card {

    @Id
    private Long id;

    @Column(name = "card_id", unique = true)
    private String cardId;

    private String memberCi;

    private Long accountId;

    private String cardNum;

    private Boolean isConsent;

    private String cardCompany;

    private String cardName;

    private Integer cardMember;

    private String cardType;

    private Long annualFee;

    private LocalDateTime issueDate;

}
