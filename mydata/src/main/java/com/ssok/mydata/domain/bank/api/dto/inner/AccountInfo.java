package com.ssok.mydata.domain.bank.api.dto.inner;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
public class AccountInfo {

        // 얘는 임시로 제공
        @JsonProperty("bank")
        private String bank;

        @JsonProperty("currency_code")
        private String currencyCode;

        @JsonProperty("saving_method")
        private String savingMethod;

        @JsonProperty("holder_name")
        private String holderName;

        @JsonProperty("issue_date")
        private LocalDateTime issueDate;

        @JsonProperty("exp_date")
        private LocalDateTime expDate;

        @JsonProperty("commit_amt")
        private Double commitAmt;

        @JsonProperty("monthly_paid_in_amt")
        private Double monthlyPaidInAmt;

        @Builder
        public AccountInfo(String bank, String savingMethod, String holderName, LocalDateTime issueDate) {
                this.bank = bank;
                this.savingMethod = savingMethod;
                this.holderName = holderName;
                this.issueDate = issueDate;
        }
}