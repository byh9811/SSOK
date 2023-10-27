package com.ssok.mydata.domain.card.api.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
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
