package com.ssok.mydata.domain.pos.api.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Setter
@AllArgsConstructor
@Builder
public class PosPayResponse {

    @JsonProperty("rsp_code")
    private String rspCode;

    @JsonProperty("rsp_msg")
    private String rspMsg;

    @JsonProperty("approved_num")
    private String approvedNum;

    @JsonProperty("approved_dtime")
    private LocalDateTime approvedDtime;

}
