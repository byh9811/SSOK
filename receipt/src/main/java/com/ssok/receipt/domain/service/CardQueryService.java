package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.response.CardQueryResponse;
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
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class CardQueryService {

    private final CardRepository cardRepository;
    private final MemberClient memberClient;

    public CardQueryResponse getCard(String memberUUID) {
        // 1. UUID로 Seq 획득
        Long memberSeq = memberClient.getMemberSeq(memberUUID).getResponse();

        // 2. Seq로 Username 획득
        String memberName = memberClient.getMemberName(memberSeq).getResponse();

        // 3. 보유한 Card 조회
        Card card = cardRepository.findByMemberSeq(memberSeq).get();

        return CardQueryResponse.from(card, memberName);
    }

}
