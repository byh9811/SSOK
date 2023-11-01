package com.ssok.receipt.domain.api.dto.response;

import lombok.Builder;

@Builder
public record ReceiptJoinResponse(String nickname, int age) {

}