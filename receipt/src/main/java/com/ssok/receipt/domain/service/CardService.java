package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.entity.CardCompany;
import com.ssok.receipt.domain.maria.repository.CardRepository;
import com.ssok.receipt.global.enumerate.BankName;
import com.ssok.receipt.global.openfeign.member.MemberClient;
import com.ssok.receipt.global.openfeign.mydata.CardClient;
import com.ssok.receipt.global.openfeign.mydata.dto.request.CardCreateFeignRequest;
import com.ssok.receipt.global.openfeign.mydata.dto.response.CardCreateFeignResponse;
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
    private final CardClient cardClient;
    private final MemberClient memberClient;

    public void createCard(String memberUUID) {
        // 1. UUID로 Seq 획득
        Long memberSeq = memberClient.getMemberSeq(memberUUID).getResponse();

        // 2. Seq로 memberCi 획득
        String memberCi = memberClient.getMemberCi(memberSeq).getResponse();

        int randInt = DummyUtils.getRandInt(5);
        CardCompany company = new CardCompany(randInt, BankName.valueOf(randInt).name());
        CardCreateFeignRequest request = CardCreateFeignRequest.from(memberCi, company.getCardCompanyName());
        CardCreateFeignResponse registerCard = cardClient.registerCard(request).getBody();
        Card card = Card.builder()
                .company(company)
                .memberSeq(memberSeq)
                .cardId(registerCard.cardId())
                .cardNum(request.card_num())
                .cardName(request.card_name())
                .cardExpMonth("11")
                .cardExpYear("28")
                .build();

        cardRepository.save(card);
    }

}
