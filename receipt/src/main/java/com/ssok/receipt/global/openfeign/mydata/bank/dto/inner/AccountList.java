package com.ssok.receipt.global.openfeign.mydata.bank.dto.inner;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AccountList {

        @JsonProperty("account_num")
        private String accountNum;

        @JsonProperty("is_consent")
        private Boolean isConsent;

        // 얘는 임시로 제공
        @JsonProperty("bank")
        private String bank;

        // 얘도
        @JsonProperty("balance")
        private long balance;

        @JsonProperty("seqno")
        private Integer seqNo;

        @JsonProperty("is_foreign_deposit")
        private Boolean isForeignDeposit;

        @JsonProperty("prod_name")
        private String prodName;

        @JsonProperty("is_minus")
        private Boolean isMinus;

        @JsonProperty("account_type")
        private String accountType;

        @JsonProperty("account_status")
        private String accountStatus;

        @Builder
        public AccountList(String accountNum, double balance, Boolean isConsent, String bank, String prodName, String accountType, String accountStatus) {
                this.accountNum = accountNum;
                this.balance = (long) balance;
                this.isConsent = isConsent;
                this.bank = bank;
                this.prodName = prodName;
                this.accountType = accountType;
                this.accountStatus = accountStatus;
        }
}