package com.ssok.receipt.global.openfeign.mydata.auth.dto.request;

import com.ssok.receipt.global.util.DummyUtils;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record CardCreateFeignRequest(
        String user_ci,
        String card_company,
        String card_name,
        String card_num,
        Integer card_member,
        String card_type,
        Long annual_fee,
        LocalDateTime issue_date
) {
    public static CardCreateFeignRequest from(String memberCi, String company) {
        return CardCreateFeignRequest.builder()
                .user_ci(memberCi)
                .card_company(company)
                .card_name(DummyUtils.getCardName())
                .card_num(DummyUtils.getCardNum())
                .card_member(1)
                .card_type(DummyUtils.getType(1))
                .annual_fee(100000L)
                .issue_date(LocalDateTime.now())
                .build();
    }
}
