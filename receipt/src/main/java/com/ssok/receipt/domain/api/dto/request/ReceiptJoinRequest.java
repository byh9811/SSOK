package com.ssok.receipt.domain.api.dto.request;

import lombok.Builder;

@Builder
public record ReceiptJoinRequest(String nickname, int age) {

}