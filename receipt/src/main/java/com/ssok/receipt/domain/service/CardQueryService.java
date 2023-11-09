package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.response.*;
import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.repository.CardRepository;
import com.ssok.receipt.domain.mongo.document.ReceiptDetailDocument;
import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import com.ssok.receipt.domain.mongo.repository.ReceiptDetailDocumentRepository;
import com.ssok.receipt.domain.mongo.repository.ReceiptListDocumentRepository;
import com.ssok.receipt.global.openfeign.member.MemberClient;
import com.ssok.receipt.global.openfeign.mydata.card.CardAccessUtil;
import com.ssok.receipt.global.openfeign.mydata.card.CardClient;
import com.ssok.receipt.global.openfeign.mydata.card.dto.inner.CardTransactionList;
import com.ssok.receipt.global.openfeign.mydata.card.dto.request.CardInfoRequest;
import com.ssok.receipt.global.openfeign.mydata.card.dto.request.CardTransactionListRequest;
import com.ssok.receipt.global.openfeign.mydata.card.dto.response.CardInfoResponse;
import com.ssok.receipt.global.openfeign.mydata.card.dto.response.CardTransactionListResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.*;
import java.util.*;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class CardQueryService {

    private final CardRepository cardRepository;
    private final ReceiptDetailDocumentRepository receiptDetailDocumentRepository;
    private final MemberClient memberClient;
    private final CardClient cardClient;

    public CardQueryResponse getCard(String memberUUID) {
        // 1. UUID로 Seq 획득
        Long memberSeq = memberClient.getMemberSeq(memberUUID).getResponse();

        // 2. Seq로 Username 획득
        String memberName = memberClient.getMemberName(memberSeq).getResponse();

        // 3. 보유한 Card 조회
        Card card = cardRepository.findByMemberSeq(memberSeq).get();

        return CardQueryResponse.from(card, memberName);
    }

    public Map<YearMonth, CardHistoryListResponses> getCardHistoryList(String memberUUID) {
        Map<YearMonth, List<CardHistoryListResponse>> cardHistoryListMap = new HashMap<>();

        Long memberSeq = memberClient.getMemberSeq(memberUUID).getResponse();
        String mdToken = memberClient.getMemberMyDataToken(memberSeq).getResponse();
        Card card = cardRepository.findByMemberSeq(memberSeq).get();

        CardTransactionListRequest request = CardTransactionListRequest.builder()
                .org_code("SSOK")
                .next_page(0L)
                //??
                .limit(500)
                .build();

        CardTransactionListResponse transactionListResponse = cardClient.getCardTransactionList(mdToken, getTranId(), getApiType(), card.getCardId(), request).getBody();
        List<CardTransactionList> cardHistoryListFromMydata = transactionListResponse.getApprovedList();

        // 월별로 나누기
        for(CardTransactionList cardTransactionList : cardHistoryListFromMydata) {
            YearMonth yearMonth = YearMonth.from(cardTransactionList.getApprovedDtime());
            if (!cardHistoryListMap.containsKey(yearMonth)) {
                cardHistoryListMap.put(yearMonth, new ArrayList<>());
            }
            Optional<ReceiptDetailDocument> foundDocument = receiptDetailDocumentRepository.findByApprovedNum(cardTransactionList.getApprovedNum());
            if (foundDocument.isPresent()) {
                cardHistoryListMap.get(yearMonth).add(CardHistoryListResponse.from(foundDocument.get().getReceiptDetailDocumentSeq(), cardTransactionList));
            } else {
                cardHistoryListMap.get(yearMonth).add(CardHistoryListResponse.from(null, cardTransactionList));
            }

        }

        Map<YearMonth, CardHistoryListResponses> result = new HashMap<>();
        // 월 별 계산 로직
        for(Map.Entry<YearMonth, List<CardHistoryListResponse>> entry : cardHistoryListMap.entrySet()){
            YearMonth key = entry.getKey();
            List<CardHistoryListResponse> value = entry.getValue();

            Long monthlyPay = 0L;
            for(CardHistoryListResponse response : value){
                monthlyPay += response.payAmt();
            }

            result.put(key, CardHistoryListResponses.builder()
                    .cardHistoryListResponses(value)
                    .totalHistory(value.size())
                    .totalPay(monthlyPay)
                    .build());
        }
        return result;
    }

    private String getApiType() {
        return "user-search";
    }

    private String getTranId() {
        return "1234567890M00000000000001";
    }

}
