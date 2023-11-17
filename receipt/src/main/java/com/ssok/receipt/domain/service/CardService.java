package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.entity.CardCompany;
import com.ssok.receipt.domain.maria.repository.CardCompanyRepository;
import com.ssok.receipt.domain.maria.repository.CardRepository;
import com.ssok.receipt.global.enumerate.BankName;
import com.ssok.receipt.global.openfeign.member.MemberClient;
import com.ssok.receipt.global.openfeign.member.dto.request.MydataAccountFeignRequest;
import com.ssok.receipt.global.openfeign.mydata.auth.AuthAccessUtil;
import com.ssok.receipt.global.openfeign.mydata.auth.AuthClient;
import com.ssok.receipt.global.openfeign.mydata.auth.dto.request.CardCreateFeignRequest;
import com.ssok.receipt.global.openfeign.member.dto.request.MydataAccessTokenFeignRequest;
import com.ssok.receipt.global.openfeign.mydata.bank.BankAccessUtil;
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
public class CardService {

    private final CardRepository cardRepository;
    private final CardCompanyRepository cardCompanyRepository;
    private final AuthClient authClient;
    private final AuthAccessUtil authAccessUtil;
    private final BankAccessUtil bankAccessUtil;
    private final MemberClient memberClient;

    public void createCard(String memberUUID) {
        // 1. UUID로 Seq 획득
        Long memberSeq = memberClient.getMemberSeq(memberUUID).getResponse();

        // 2. Seq로 memberCi 획득
        String memberCi = memberClient.getMemberCi(memberSeq).getResponse();

        // 3. 카드 서버에 생성한 카드 등록
        int randInt = DummyUtils.getRandInt(5);
        CardCompany company = cardCompanyRepository.save(new CardCompany(randInt, BankName.valueOf(randInt).name()));
        CardCreateFeignRequest request = CardCreateFeignRequest.from(memberCi, company.getCardCompanyName());
        String cardId = authClient.registerCard(request).getBody();

        // 4. 멤버에 mydataAccessToken 등록
        String mydataAccessToken = authAccessUtil.getMydataAccessToken(memberCi);
        MydataAccessTokenFeignRequest tokenFeignRequest = MydataAccessTokenFeignRequest.builder()
                .memberSeq(memberSeq)
                .memberMydataAccessToken(mydataAccessToken)
                .build();
        String response = memberClient.createMemberAccessToken(tokenFeignRequest).getResponse();
        log.warn("{}", mydataAccessToken);
        log.warn("{}", response);

        // 5. 계좌 등록
        AccountList account = bankAccessUtil.getAccount(mydataAccessToken);
        log.warn("{}", account.getAccountNum());
        MydataAccountFeignRequest accountFeignRequest = MydataAccountFeignRequest.builder()
                .memberSeq(memberSeq)
                .memberAccountNum(account.getAccountNum())
                .build();
        String response1 = memberClient.createMemberAccount(accountFeignRequest).getResponse();
        log.warn("{}", response1);

        // 6. 연동 카드에 생성한 카드 등록
        Card card = Card.builder()
                .company(company)
                .memberSeq(memberSeq)
                .cardId(cardId)
                .cardNum(request.card_num())
                .cardName(request.card_name())
                .cardExpMonth("11")
                .cardExpYear("28")
                .build();
        cardRepository.save(card);
    }

}
