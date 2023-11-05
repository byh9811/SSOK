package com.ssok.mydata.domain.card.api.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ssok.mydata.domain.pos.entity.Payment;
import com.ssok.mydata.global.enumerate.CardType;
import com.ssok.mydata.global.enumerate.CardTypeConverter;
import com.ssok.mydata.global.enumerate.TransactionType;
import com.ssok.mydata.global.util.DummyUtils;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

import static lombok.AccessLevel.PROTECTED;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor(access = PROTECTED)
public class PayRequest {

        private String cardId; // 결제 카드 Id

        private String cardNum; // 결제 카드 번호

        private String cardCompany; // 결제 카드 번호

        private String cardExpMonth; // 결제 카드 유효 월

        private String cardExpYear; // 결제 카드 유효 년

        private String cardType; // 결제 유형

        private Long amount; // 거래 금액

        private String type; // 승인, 취소, 정정

        private Integer installPeriod; // 할부 기간

        private String shopName; // 상호명

        private String shopNumber; // 사업자 등록 번호

        public Payment toEntity(String paymentApprovedNum, LocalDateTime paymentTransactionDatetime) {
                return Payment.builder()
                        .paymentCardNum(cardNum)
                        .paymentCardType(CardType.valueOf(cardType))
                        .paymentCardCompany(cardCompany)
                        .paymentAmount(amount)
                        .paymentType(TransactionType.valueOf(cardType))
                        .paymentInstallPeriod(installPeriod)
                        .paymentBusinessNumber(shopNumber)
                        .paymentStoreName(shopName)
                        .paymentApprovedNum(paymentApprovedNum)
                        .paymentTransactionDatetime(paymentTransactionDatetime)
                        .paymentReceiptNumber(DummyUtils.createReceiptNumber(paymentApprovedNum))
                        .build();
        }
}