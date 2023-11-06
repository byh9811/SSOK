package com.ssok.receipt.global.openfeign.mydata.card.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CardInfoRequest {

    private String org_code;

    private Long search_timestamp;

    private Long next_page;

    private Integer limit;

}
