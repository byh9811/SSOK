package com.ssok.receipt.global.openfeign.mydata.dto.request;

import com.ssok.receipt.global.util.DummyUtils;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record MydataAccessTokenFeignRequest(
        Long memberSeq,
        String mydataAccessToken
) {
}
