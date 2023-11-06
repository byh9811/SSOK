package com.ssok.mydata.domain.card.service;

import com.ssok.mydata.domain.card.api.dto.request.PayRequest;
import com.ssok.mydata.domain.card.api.dto.request.TransactionRequest;
import com.ssok.mydata.domain.card.api.dto.response.PayResponse;
import com.ssok.mydata.domain.card.repository.CardHistoryRepository;
import com.ssok.mydata.global.util.DummyUtils;
import com.ssok.mydata.domain.card.entity.Card;
import com.ssok.mydata.domain.card.entity.CardHistory;
import com.ssok.mydata.domain.card.repository.CardRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class CardService {

    private final CardRepository cardRepository;
    private final CardHistoryRepository cardHistoryRepository;

    public PayResponse pay(PayRequest payRequest) {
//        if (!cardRepository.existsByMemberCi(memberCi)) {
//            throw new RuntimeException("당신의 카드가 아닙니다.");
//        }

        Card card = cardRepository.findByCardId(payRequest.getCardId()).get();
        String approvedNum = DummyUtils.createApprovedNum();
        CardHistory cardHistory = CardHistory.builder()
                .card(card)
                .approvedNum(approvedNum)
                .approvedDtime(LocalDateTime.now())
                .status(payRequest.getType())
                .payType(payRequest.getCardType())
                .merchantName(payRequest.getShopName())
                .merchantRegno(payRequest.getShopNumber())
                .approvedAmt(payRequest.getAmount())
                .build();
        cardHistoryRepository.save(cardHistory);

        return PayResponse.builder()
                .approvedNum(cardHistory.getApprovedNum())
                .approvedDtime(cardHistory.getApprovedDtime())
                .build();
    }

}
