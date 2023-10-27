package com.ssok.mydata.domain.card.api.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.util.Date;

@NoArgsConstructor
@Getter
@Setter
@AllArgsConstructor
@Builder
public class PayResponse {

    @JsonProperty("rsp_code")
    private String rspCode;

    @JsonProperty("rsp_msg")
    private String rspMsg;

    @JsonProperty("approved_num")
    private String approvedNum;

    @JsonProperty("approved_dtime")
    private Date approvedDtime;

}
