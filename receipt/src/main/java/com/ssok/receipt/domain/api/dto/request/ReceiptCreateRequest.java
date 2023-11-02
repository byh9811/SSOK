package com.ssok.receipt.domain.api.dto.request;

import lombok.Builder;

@Builder
public record ReceiptCreateRequest(String nickname, int age) {

}