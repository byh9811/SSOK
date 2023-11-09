package com.ssok.receipt.global.openfeign.mydata.card;

import com.ssok.receipt.global.openfeign.mydata.card.dto.inner.CardList;
import com.ssok.receipt.global.openfeign.mydata.card.dto.inner.CardTransactionList;
import com.ssok.receipt.global.openfeign.mydata.card.dto.request.CardListRequest;
import com.ssok.receipt.global.openfeign.mydata.card.dto.request.CardTransactionListRequest;
import com.ssok.receipt.global.openfeign.mydata.card.dto.response.CardListResponse;
import com.ssok.receipt.global.openfeign.mydata.card.dto.response.CardTransactionListResponse;
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
public class CardAccessUtil {

    private final CardClient cardClient;

    private String orgCode = "ssok";

    public List<CardList> getCardList(String mydataAccessToken) {
        CardListResponse cardListResponse = cardClient.getCardList(
                        mydataAccessToken,
                        getTranId(),
                        getApiType(),
                        createCardListRequest())
                .getBody();

        if (cardListResponse == null) {
            throw new RuntimeException("계좌 정보를 찾을 수 없습니다!!");
        }

        return cardListResponse.getCardList();
    }

    private String getApiType() {
        return "user-search";
    }

    private String getTranId() {
        return "1234567890M00000000000001";
    }

    private CardListRequest createCardListRequest() {
        return CardListRequest.builder()
                .org_code(orgCode)
                .search_timestamp(new Date().getTime())
                .next_page(0L)
                .limit(500)
                .build();
    }

    private CardTransactionListRequest createCardTransactionListRequest() {
        return CardTransactionListRequest.builder()
                .org_code(orgCode)
                .limit(500)
                .build();
    }

}
