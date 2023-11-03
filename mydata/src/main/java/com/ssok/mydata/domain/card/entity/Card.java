package com.ssok.mydata.domain.card.entity;

import lombok.*;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.sql.Date;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Card {

    @Id
    private String card_id;

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
