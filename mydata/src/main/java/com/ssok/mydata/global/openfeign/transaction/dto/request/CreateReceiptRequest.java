package com.ssok.mydata.global.openfeign.transaction.dto.request;

import com.ssok.mydata.domain.pos.api.dto.inner.InnerPaymentItem;
import com.ssok.mydata.domain.pos.entity.Payment;
import com.ssok.mydata.domain.pos.entity.PaymentItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@Builder
public class CreateReceiptRequest {

    private String cardNum; // 결제 카드 번호

    private String cardType; // 결제 유형

    private Long amount; // 거래 금액

    private String type; // 승인, 취소, 정정

    private String approvedNum; // 승인 번호

    private Integer installPeriod; // 할부 기간

    private String shopName; // 상호명

    private String shopNumber; // 사업자 등록 번호

    private String receiptNumber; // 영수증 번호

    private LocalDateTime transactionDatetime;

    private List<PaymentItem> paymentItemList; // 구매 품목 리스트

    public static CreateReceiptRequest fromEntity(String cardNum, Payment payment, List<PaymentItem> paymentItemList) {
        return CreateReceiptRequest.builder()
                .cardNum(cardNum)
                .cardType(payment.getPaymentCardType().getCode())
                .amount(payment.getPaymentAmount())
                .type(payment.getPaymentType().getCode())
                .approvedNum(payment.getPaymentApprovedNum())
                .installPeriod(payment.getPaymentInstallPeriod())
                .shopName(payment.getPaymentStoreName())
                .shopNumber(payment.getPaymentBusinessNumber())
                .receiptNumber(payment.getPaymentReceiptNumber())
                .transactionDatetime(payment.getPaymentTransactionDatetime())
                .paymentItemList(paymentItemList)
                .build();
    }

}