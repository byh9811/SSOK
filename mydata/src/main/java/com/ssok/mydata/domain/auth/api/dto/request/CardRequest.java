package com.ssok.mydata.domain.auth.api.dto.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Id;
import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
public class CardRequest {

    private String userCi;

    private String cardCompany;

    private String cardName;

    private String cardNum;

    private Integer cardMember;

    private String cardType;

    private Long annualFee;

    private LocalDateTime issueDate;

}
