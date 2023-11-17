package com.ssok.receipt.domain.api.dto.request;

import com.ssok.receipt.domain.api.dto.inner.InnerPaymentItem;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.List;

@Builder
public record ReceiptQueryRequest(
        int year,
        int month
) {

}