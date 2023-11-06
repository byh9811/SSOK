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

//    // 태산 적금통에서 내 계좌로 이체시 이 로직 사용 (적금통 해지)
//    public void transfer(Member member) {
//        Tikkle tikkle = tikkleRepository.findByMemberId(member.getId()).get();
//        TransferRequest transferRequest = createTransferRequest(member, money);
//        bankClient.transfer(member.getMydataAccessToken(), transferRequest);
//    }
//
//    // 내 계좌에서 적금통으로 금액 이동시 이 로직 사용
//    public void charge(Member member, Long money) {
//        ChargeRequest chargeRequest = createChargeRequest(member, money);
//        bankClient.charge(member.getMydataAccessToken(), chargeRequest);
//    }

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

//    private TransferRequest createTransferRequest(Member member, Long money) {
//        return TransferRequest.builder()
//                .receiverAccNum(member.getAccountNum())
//                .transAmt(money)
//                .build();
//    }
//
//    private ChargeRequest createChargeRequest(Member member, Long money) {
//        return ChargeRequest.builder()
//                .senderAccNum(member.getAccountNum())
//                .transAmt(money)
//                .build();
//    }

}
