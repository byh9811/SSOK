package com.ssok.receipt.global.openfeign.mydata.card;

import com.ssok.receipt.global.config.OpenFeignConfig;
import com.ssok.receipt.global.openfeign.mydata.card.dto.request.CardInfoRequest;
import com.ssok.receipt.global.openfeign.mydata.card.dto.request.CardListRequest;
import com.ssok.receipt.global.openfeign.mydata.card.dto.request.CardTransactionListRequest;
import com.ssok.receipt.global.openfeign.mydata.card.dto.response.CardInfoResponse;
import com.ssok.receipt.global.openfeign.mydata.card.dto.response.CardListResponse;
import com.ssok.receipt.global.openfeign.mydata.card.dto.response.CardTransactionListResponse;
import com.ssok.receipt.global.openfeign.mydata.card.dto.response.PayResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@FeignClient(name = "card", url = "https://k9c107.p.ssafy.io/mydata/card-management/cards", configuration = OpenFeignConfig.class)
public interface CardClient {

    @GetMapping
    ResponseEntity<CardListResponse> getCardList(
            @RequestHeader("Authorization") String token,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @SpringQueryMap CardListRequest cardListRequest);

    @GetMapping("/{card_id}")
    ResponseEntity<CardInfoResponse> getCardInfo(
            @RequestHeader("Authorization") String token,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @PathVariable("card_id") long cardId,
            @SpringQueryMap CardInfoRequest cardInfoRequest);

    @GetMapping("/{card_id}/approval-domestic")
    ResponseEntity<CardTransactionListResponse> getCardTransactionList(
            @RequestHeader("Authorization") String token,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @PathVariable("card_id") String cardId,
            @SpringQueryMap CardTransactionListRequest cardTransactionListRequest);

}
