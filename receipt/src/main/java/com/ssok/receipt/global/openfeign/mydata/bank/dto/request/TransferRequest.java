package com.ssok.receipt.global.openfeign.mydata.bank.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TransferRequest {

    @JsonProperty("receiver_acc_num")
    private String receiverAccNum;

    @JsonProperty("trans_amt")
    private Long transAmt;

}
