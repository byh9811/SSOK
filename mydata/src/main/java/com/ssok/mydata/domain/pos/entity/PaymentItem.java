package com.ssok.mydata.domain.pos.entity;

import com.ssok.mydata.domain.card.entity.Card;
import com.ssok.mydata.global.enumerate.CardType;
import com.ssok.mydata.global.enumerate.CardTypeConverter;
import com.ssok.mydata.global.enumerate.TransactionTypeConverter;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class PaymentItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long paymentItemSeq;

    @JoinColumn(name = "payment_seq")
    @ManyToOne(fetch = FetchType.LAZY)
    private Payment payment;

    private String paymentItemName;

    private Long paymentItemPrice;

    private Long paymentItemCnt;

}
