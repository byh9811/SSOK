package com.ssok.receipt.global.openfeign.member.dto.request;

import lombok.Builder;

@Builder
public record MydataAccountFeignRequest(
        Long memberSeq,
        String memberAccountNum
) {
}
