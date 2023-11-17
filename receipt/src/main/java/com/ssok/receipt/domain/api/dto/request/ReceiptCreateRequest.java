package com.ssok.receipt.domain.api.dto.request;

import com.ssok.receipt.domain.api.dto.inner.InnerPaymentItem;
import lombok.*;

import javax.persistence.Convert;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import java.time.LocalDateTime;
import java.util.List;

@Builder
public record ReceiptCreateRequest(
        String cardNum,
        String cardType,
        String approvedNum,
        Long amount,
        String type,
        Integer installPeriod,
        String shopNumber,
        String shopName,
        String receiptNumber,
        LocalDateTime transactionDatetime,
        List<InnerPaymentItem> paymentItemList
) {

}