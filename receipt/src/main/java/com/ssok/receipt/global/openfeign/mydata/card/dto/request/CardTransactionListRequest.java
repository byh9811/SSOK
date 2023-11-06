package com.ssok.receipt.global.openfeign.mydata.card.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.sql.Date;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CardTransactionListRequest {

    private String org_code;

    private String from_date;

    private String to_date;

    private Long next_page;

    private Integer limit;

}
