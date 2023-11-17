package com.ssok.mydata.domain.card.api.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.time.LocalDateTime;
import java.util.Date;

@NoArgsConstructor
@Getter
@Setter
@AllArgsConstructor
@Builder
public class PayResponse {

    private String approvedNum;

    private LocalDateTime approvedDtime;

}
