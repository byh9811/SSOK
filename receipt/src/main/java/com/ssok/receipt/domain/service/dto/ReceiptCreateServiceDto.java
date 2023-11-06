package com.ssok.receipt.domain.service.dto;

import com.ssok.receipt.domain.api.dto.inner.InnerPaymentItem;
import com.ssok.receipt.domain.api.dto.request.ReceiptCreateRequest;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.List;

@Builder
public record ReceiptCreateServiceDto(
        String receiptCardNum,
        String receiptCardType,
        String receiptApprovedNum,
        Long receiptAmount,
        String receiptType,
        Integer receiptInstallPeriod,
        String receiptBusinessNumber,
        String receiptStoreName,
        String receiptNumber,
        LocalDateTime receiptTransactionDatetime,
        List<InnerPaymentItem> paymentItemList
) {

    public static ReceiptCreateServiceDto fromRequest(ReceiptCreateRequest request) {
        return ReceiptCreateServiceDto.builder()
                .receiptCardNum(request.cardNum())
                .receiptCardType(request.cardType())
                .receiptApprovedNum(request.approvedNum())
                .receiptAmount(request.amount())
                .receiptType(request.type())
                .receiptInstallPeriod(request.installPeriod())
                .receiptTransactionDatetime(request.transactionDatetime())
                .receiptBusinessNumber(request.shopNumber())
                .receiptStoreName(request.shopName())
                .receiptNumber(request.receiptNumber())
                .paymentItemList(request.paymentItemList())
                .build();
    }

}