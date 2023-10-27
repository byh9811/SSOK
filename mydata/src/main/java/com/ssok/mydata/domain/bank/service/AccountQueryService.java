package com.ssok.mydata.domain.bank.service;

import com.ssok.mydata.domain.bank.api.dto.inner.AccountDetail;
import com.ssok.mydata.domain.bank.api.dto.inner.AccountInfo;
import com.ssok.mydata.domain.bank.api.dto.inner.AccountList;
import com.ssok.mydata.domain.bank.api.dto.response.AccountDetailResponse;
import com.ssok.mydata.domain.bank.api.dto.response.AccountInfoResponse;
import com.ssok.mydata.domain.bank.api.dto.response.AccountListResponse;
import com.ssok.mydata.domain.bank.repository.AccountQueryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AccountQueryService {

    private final AccountQueryRepository accountQueryRepository;

    public AccountListResponse findAccountList(long memberCi, long cursor, int limit) {

        List<AccountList> accountList = accountQueryRepository.findAccountListByMemberCi(memberCi, cursor, limit);
        return AccountListResponse.builder()
                .accountList(accountList)
                .regDate("20170203")
                .nextPage(cursor + limit)
                .build();
    }

    public AccountInfoResponse findAccountInfo(String accountNum) {

        List<AccountInfo> accountInfos = accountQueryRepository.findAccountInfoByAccountNum(accountNum);

        return AccountInfoResponse.builder()
                .basicList(accountInfos)
                .build();
    }

    public AccountDetailResponse findAccountDetail(String accountNum) {

        List<AccountDetail> accountInfos = accountQueryRepository.findAccountDetailByAccountNum(accountNum);

        return AccountDetailResponse.builder()
                .detailList(accountInfos)
                .build();
    }

}
