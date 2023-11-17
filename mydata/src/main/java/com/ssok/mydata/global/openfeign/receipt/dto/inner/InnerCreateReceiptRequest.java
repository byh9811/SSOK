package com.ssok.mydata.global.openfeign.receipt.dto.inner;

import com.ssok.mydata.domain.pos.entity.PaymentItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
public class InnerCreateReceiptRequest {

    private String itemName;

    private Long itemPrice;

    private Long itemCnt;

    public static InnerCreateReceiptRequest from(PaymentItem paymentItem) {
        return InnerCreateReceiptRequest.builder()
                .itemName(paymentItem.getPaymentItemName())
                .itemPrice(paymentItem.getPaymentItemPrice())
                .itemCnt(paymentItem.getPaymentItemCnt())
                .build();
    }
}