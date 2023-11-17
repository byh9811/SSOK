package com.ssok.mydata.domain.pos.entity;

import com.ssok.mydata.global.enumerate.CardType;
import com.ssok.mydata.global.enumerate.CardTypeConverter;
import com.ssok.mydata.global.enumerate.TransactionType;
import com.ssok.mydata.global.enumerate.TransactionTypeConverter;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long paymentSeq;

    private String paymentCardNum;

    @Convert(converter = CardTypeConverter.class)
    private CardType paymentCardType;

    private String paymentCardCompany;

    private String paymentApprovedNum;

    private Long paymentAmount;

    @Convert(converter = TransactionTypeConverter.class)
    private TransactionType paymentType;

    private Integer paymentInstallPeriod;

    private LocalDateTime paymentTransactionDatetime;

    private String paymentBusinessNumber;

    private String paymentStoreName;

    private String paymentReceiptNumber;

}
