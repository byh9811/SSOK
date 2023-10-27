package com.ssok.mydata.domain.card.service;

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

import java.sql.Timestamp;

@Service
@RequiredArgsConstructor
@Slf4j
public class CardService {

    private final CardRepository cardRepository;
    private final CardHistoryRepository cardHistoryRepository;
//    private final TransactionClient transactionClient;
    private final DummyUtils dummyUtils;

    public PayResponse pay(Long memberId, Long cardId, TransactionRequest transactionRequest) {
        if (!cardRepository.existsByMemberCi(memberId)) {
            throw new RuntimeException("당신의 카드가 아닙니다.");
        }
        Card card = cardRepository.findById(cardId).get();
        CardHistory cardHistory = CardHistory.builder()
                .id(transactionRequest.getCardHistoryId())
                .card(card)
                .approvedNum(transactionRequest.getApprovedNum())
                .approvedDtime(Timestamp.valueOf(transactionRequest.getDateTime()))
                .status("01")
                .payType(transactionRequest.getCardType())
                .merchantName(transactionRequest.getShopName())
                .merchantRegno(transactionRequest.getShopNumber())
                .approvedAmt(transactionRequest.getApprovedAmount())
                .build();
        cardHistoryRepository.save(cardHistory);
//        transactionClient.saveNewTransaction(accessToken, cardId, new CardHistoryList(cardHistory));

        return PayResponse.builder()
                .rspCode("200")
                .rspMsg("성공")
                .approvedDtime(cardHistory.getApprovedDtime())
                .approvedNum(cardHistory.getApprovedNum())
                .build();
    }

}
