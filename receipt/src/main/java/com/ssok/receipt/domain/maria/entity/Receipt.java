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
public class Receipt extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long receiptSeq;

    private String receiptCardNum;

    @Convert(converter = CardTypeConverter.class)
    private CardType receiptCardType;

    private String receiptApprovedNum;

    private Long receiptAmount;

    @Convert(converter = TransactionTypeConverter.class)
    private TransactionType receiptTransactionType;

    private Integer receiptInstallPeriod;

    private LocalDateTime receiptTransactionDatetime;

    private String receiptBusinessNumber;

    private String receiptStoreName;

    private String receiptReceiptNumber;


    public static Receipt fromCreateDto(ReceiptCreateServiceDto dto) {
        return Receipt.builder()
                .receiptCardNum(dto.receiptCardNum())
                .receiptCardType(CardType.fromCode(dto.receiptCardType()))
                .receiptApprovedNum(dto.receiptApprovedNum())
                .receiptAmount(dto.receiptAmount())
                .receiptTransactionType(TransactionType.fromCode(dto.receiptType()))
                .receiptInstallPeriod(dto.receiptInstallPeriod())
                .receiptTransactionDatetime(dto.receiptTransactionDatetime())
                .receiptBusinessNumber(dto.receiptBusinessNumber())
                .receiptStoreName(dto.receiptStoreName())
                .receiptReceiptNumber(dto.receiptNumber())
                .build();


    }

}
