package com.ssok.receipt.domain.api.dto.inner;

import lombok.Builder;

import javax.persistence.*;

@Builder
public record InnerPaymentItem(
        String itemName,
        Long itemPrice,
        Long itemCnt
) {

}
