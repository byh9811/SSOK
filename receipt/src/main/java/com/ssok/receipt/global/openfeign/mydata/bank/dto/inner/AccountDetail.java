package com.ssok.receipt.global.openfeign.mydata.bank.dto.inner;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AccountDetail {

        @JsonProperty("account_name")
        private String accountName;

        @JsonProperty("currency_code")
        private String currencyCode;

        @JsonProperty("balance_amt")
        private double balanceAmt;

        @JsonProperty("withdrawable_amt")
        private double withdrawableAmt;

        @JsonProperty("offered_rate")
        private double offeredRate;

        @JsonProperty("last_paid_in_cnt")
        private String lastPaidInCnt;

        @Builder
        public AccountDetail(String accountName, String currencyCode, Double balanceAmt, Double withdrawableAmt, Double offeredRate) {
                this.accountName = accountName;
                this.currencyCode = currencyCode;
                this.balanceAmt = balanceAmt;
                this.withdrawableAmt = withdrawableAmt;
                this.offeredRate = offeredRate;
        }
}