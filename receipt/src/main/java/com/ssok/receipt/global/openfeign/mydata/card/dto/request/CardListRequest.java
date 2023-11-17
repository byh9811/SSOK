package com.ssok.receipt.global.openfeign.mydata.card.dto.request;

import lombok.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CardListRequest {

    private String org_code;

    private Long search_timestamp;

    private Long next_page;

    private Integer limit;

}
