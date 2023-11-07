package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.response.AccountInfoResponse;
import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.entity.CardCompany;
import com.ssok.receipt.domain.maria.repository.CardCompanyRepository;
import com.ssok.receipt.domain.maria.repository.CardRepository;
import com.ssok.receipt.global.enumerate.BankName;
import com.ssok.receipt.global.openfeign.member.MemberClient;
import com.ssok.receipt.global.openfeign.member.dto.request.MydataAccessTokenFeignRequest;
import com.ssok.receipt.global.openfeign.member.dto.request.MydataAccountFeignRequest;
import com.ssok.receipt.global.openfeign.mydata.auth.AuthAccessUtil;
import com.ssok.receipt.global.openfeign.mydata.auth.AuthClient;
import com.ssok.receipt.global.openfeign.mydata.auth.dto.request.CardCreateFeignRequest;
import com.ssok.receipt.global.openfeign.mydata.bank.BankAccessUtil;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.inner.AccountDetail;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.inner.AccountInfo;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.inner.AccountList;
import com.ssok.receipt.global.util.DummyUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class AccountQueryService {

    private final BankAccessUtil bankAccessUtil;
    private final MemberClient memberClient;

    public AccountInfoResponse getAccountInfo(String memberUUID) {
        // 1. UUID로 Seq 획득
        Long memberSeq = memberClient.getMemberSeq(memberUUID).getResponse();

        // 2. 계좌주 이름 가져오기
        String memberName = memberClient.getMemberName(memberSeq).getResponse();

        // 3. 계좌 번호 가져오기
        String accountNum = memberClient.getMemberAccount(memberSeq).getResponse();

        // 4. 마이데이터 토큰 가져오기
        String mdToken = memberClient.getMemberMyDataToken(memberSeq).getResponse();

        // 5. 은행명 가져오기
        AccountInfo accountInfo = bankAccessUtil.getAccountInfo(mdToken, accountNum);
        String bankName = accountInfo.getBank();

        // 6. 계좌 잔액 가져오기
        AccountDetail accountDetail = bankAccessUtil.getAccountDetail(mdToken, accountNum);
        double balanceAmt = accountDetail.getBalanceAmt();

        // 7. 계좌 정보 생성 & 리턴
        return AccountInfoResponse.builder()
                .name(memberName)
                .bank(bankName)
                .accNum(accountNum)
                .balance((long) balanceAmt)
                .build();
    }

    public Long transfer(Long memberSeq, Long amt) {
        // 1. 계좌 번호 가져오기
        String accountNum = memberClient.getMemberAccount(memberSeq).getResponse();

        // 2. 마이데이터 토큰 가져오기
        String mdToken = memberClient.getMemberMyDataToken(memberSeq).getResponse();

        bankAccessUtil.transfer(mdToken, accountNum, amt);
        return amt;
    }

}
