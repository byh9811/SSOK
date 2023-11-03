package com.ssok.mydata.domain.auth.api.dto.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Id;
import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
public class CardRequest {

    private String user_ci;

    private String card_company;

    private String card_name;

    private String card_num;

    private Integer card_member;

    private String card_type;

    private Long annual_fee;

    private LocalDateTime issue_date;

}
