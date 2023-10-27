package com.ssok.mydata.domain.card.service;

import com.ssok.mydata.domain.card.api.dto.inner.CardTransactionList;
import com.ssok.mydata.domain.card.api.dto.response.CardTransactionListResponse;
import com.ssok.mydata.domain.card.repository.CardHistoryQueryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CardHistoryQueryService {

    private final CardHistoryQueryRepository cardHistoryQueryRepository;

    public CardTransactionListResponse findCardHistory(long cardId, Long cursor, int limit) {
        List<CardTransactionList> cardList = cardHistoryQueryRepository.findCardTransactionList(cardId, cursor, limit);
        if (cardList.isEmpty()) {
            return CardTransactionListResponse.builder()
                    .nextPage(null)
                    .approvedList(cardList)
                    .build();
        } else {
            return CardTransactionListResponse.builder()
                    .nextPage(cardList.size()==limit+1 ? cardList.get(cardList.size()-1).getId() : null)
                    .approvedList(cardList.subList(0, cardList.size()-1))
                    .build();
        }
    }

    public Long findLastCardHistoryId() {
        return cardHistoryQueryRepository.count();
    }
}
