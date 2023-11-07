package com.ssok.mydata.domain.bank.entity;

import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String memberCi;

    private String bank;

    private String prodName;

    private LocalDateTime issueDate;

    private String accountNum;

    private String currencyCode;

    private String savingMethod;

    private LocalDateTime expDate;

    private Double commitAmt;

    private Double monthlyPaidInAmt;

    private Double balanceAmt;

    private Double withdrawableAmt;

    private Double offeredRate;

    private Integer lastPaidInCnt;

    public void withdraw(Long amt) {
        balanceAmt -= amt;
    }

    public void deposit(Long amt) {
        balanceAmt += amt;
    }

}
