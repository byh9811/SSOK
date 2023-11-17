package com.ssok.receipt.global.openfeign.mydata.bank;

import com.ssok.receipt.global.openfeign.mydata.bank.dto.inner.AccountDetail;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.inner.AccountInfo;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.inner.AccountList;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.request.*;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.response.AccountDetailResponse;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.response.AccountInfoResponse;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.response.AccountListResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class BankAccessUtil {

    private final BankClient bankClient;

    private String orgCode = "ssok";

    public AccountList getAccount(String mydataAccessToken) {
        log.warn("{}", mydataAccessToken);
        AccountListResponse accountListResponse = bankClient.getAccountList(
                        mydataAccessToken,
                        getTranId(),
                        getApiType(),
                        createAccountListRequest())
                .getBody();

        if (accountListResponse == null) {
            throw new RuntimeException("계좌 정보를 찾을 수 없습니다!!");
        }

        return accountListResponse.getAccountList().get(0);
    }

    public AccountInfo getAccountInfo(String mydataAccessToken, String accountNum) {
        AccountInfoResponse accountInfoResponse = bankClient.getAccountInfo(
                        mydataAccessToken,
                        getTranId(),
                        getApiType(),
                        createAccountInfoRequest(accountNum))
                .getBody();

        if (accountInfoResponse == null) {
            throw new RuntimeException("계좌 정보를 찾을 수 없습니다!!");
        }

        return accountInfoResponse.getBasicList().get(0);
    }

    public AccountDetail getAccountDetail(String mydataAccessToken, String accountNum) {
        AccountDetailResponse accountDetailResponse = bankClient.getAccountDetail(
                        mydataAccessToken,
                        getTranId(),
                        getApiType(),
                        createAccountDetailRequest(accountNum))
                .getBody();

        if (accountDetailResponse == null) {
            throw new RuntimeException("계좌 정보를 찾을 수 없습니다!!");
        }

        return accountDetailResponse.getDetailList().get(0);
    }

    public void transfer(String mdToken, String accNum, Long amt) {
        TransferRequest transferRequest = createTransferRequest(accNum, amt);
        bankClient.transfer(mdToken, transferRequest);
    }

    public void pay(String mdToken, String accNum, Long amt) {
        ChargeRequest chargeRequest = createChargeRequest(accNum, amt);
        bankClient.charge(mdToken, chargeRequest);
    }

    private String getApiType() {
        return "user-search";
    }

    private String getTranId() {
        return "1234567890M00000000000001";
    }

    private AccountListRequest createAccountListRequest() {
        return AccountListRequest.builder()
                .org_code(orgCode)
                .search_timestamp(new Date().getTime())
                .next_page(0)
                .limit(500)
                .build();
    }

    private AccountInfoRequest createAccountInfoRequest(String accountNum) {
        return AccountInfoRequest.builder()
                .org_code(orgCode)
                .account_num(accountNum)
                .seqno(1)
                .search_timestamp(new Date().getTime())
                .next_page(0L)
                .limit(500)
                .build();
    }

    private AccountDetailRequest createAccountDetailRequest(String accountNum) {
        return AccountDetailRequest.builder()
                .org_code(orgCode)
                .account_num(accountNum)
                .seqno(1)
                .search_timestamp(new Date().getTime())
                .build();
    }

    private TransferRequest createTransferRequest(String accNum, Long amt) {
        return TransferRequest.builder()
                .receiverAccNum(accNum)
                .transAmt(amt)
                .build();
    }

    private ChargeRequest createChargeRequest(String accNum, Long money) {
        return ChargeRequest.builder()
                .senderAccNum(accNum)
                .transAmt(money)
                .build();
    }

}
