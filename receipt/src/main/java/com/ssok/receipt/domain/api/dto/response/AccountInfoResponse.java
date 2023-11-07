package com.ssok.receipt.domain.api.dto.response;

import com.ssok.receipt.domain.maria.entity.Card;
import lombok.Builder;

@Builder
public record AccountInfoResponse(
    String name,
    Long balance,
    String bank,
    String accNum
) {

}