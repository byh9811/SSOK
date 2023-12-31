package com.ssok.mydata.domain.pos.api.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ssok.mydata.domain.card.api.dto.request.PayRequest;
import com.ssok.mydata.domain.pos.api.dto.inner.InnerPaymentItem;
import com.ssok.mydata.domain.pos.entity.Item;
import com.ssok.mydata.domain.pos.entity.Payment;
import com.ssok.mydata.domain.pos.entity.PaymentItem;
import com.ssok.mydata.global.enumerate.CardType;
import com.ssok.mydata.global.enumerate.TransactionType;
import com.ssok.mydata.global.util.DummyUtils;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@Getter
public class PosPayRequest {

        private String cardNum; // 결제 카드 번호

        private String cardType; // 결제 유형

        private Long amount; // 거래 금액

        private String type; // 승인, 취소, 정정

        private Integer installPeriod; // 할부 기간

        private String shopName; // 상호명

        private String shopNumber; // 사업자 등록 번호

        private List<InnerPaymentItem> paymentItemList; // 구매 품목 리스트

        public PayRequest toPayRequest() {
                return PayRequest.builder()
                        .cardNum(cardNum)
                        .cardType(cardType)
                        .amount(amount)
                        .type(type)
                        .installPeriod(installPeriod)
                        .shopName(shopName)
                        .shopNumber(shopNumber)
                        .build();
        }

        public Payment toPayment(String cardCompany, String paymentApprovedNum, LocalDateTime paymentTransactionDatetime) {
                return Payment.builder()
                        .paymentCardNum(cardNum)
                        .paymentCardType(CardType.fromCode(cardType))
                        .paymentCardCompany(cardCompany)
                        .paymentAmount(amount)
                        .paymentType(TransactionType.fromCode(type))
                        .paymentInstallPeriod(installPeriod)
                        .paymentBusinessNumber(shopNumber)
                        .paymentStoreName(shopName)
                        .paymentApprovedNum(paymentApprovedNum)
                        .paymentTransactionDatetime(paymentTransactionDatetime)
                        .paymentReceiptNumber(DummyUtils.createReceiptNumber(paymentApprovedNum))
                        .build();
        }
}
