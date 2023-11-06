package com.ssok.receipt.domain.maria.entity;

import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
import com.ssok.receipt.global.entity.BaseEntity;
import com.ssok.receipt.global.enumerate.CardType;
import com.ssok.receipt.global.enumerate.CardTypeConverter;
import com.ssok.receipt.global.enumerate.TransactionType;
import com.ssok.receipt.global.enumerate.TransactionTypeConverter;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
public class Card extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long cardSeq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "card_company_code")
    private CardCompany company;

    private Long memberSeq;

    private String cardId;

    private String cardNum;

    private String cardName;

    private String cardExpMonth;

    private String cardExpYear;

}
