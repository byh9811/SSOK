package com.ssok.mydata.domain.card.api;

import com.ssok.mydata.domain.card.api.dto.request.*;
import com.ssok.mydata.domain.card.api.dto.response.CardInfoResponse;
import com.ssok.mydata.domain.card.api.dto.response.CardListResponse;
import com.ssok.mydata.domain.card.api.dto.response.CardTransactionListResponse;
import com.ssok.mydata.domain.card.api.dto.response.PayResponse;
import com.ssok.mydata.domain.card.service.CardHistoryQueryService;
import com.ssok.mydata.domain.card.service.CardQueryService;
import com.ssok.mydata.domain.card.service.CardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/mydata/card-management/cards")
public class CardApi {

    private final CardQueryService cardQueryService;
    private final CardHistoryQueryService cardHistoryQueryService;
    private final CardService cardService;

    @GetMapping
    public ResponseEntity<CardListResponse> getCardList(
            @AuthenticationPrincipal User user,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @Valid @ModelAttribute CardListRequest accountListRequest)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.add("x-api-tran-id", "1234567890M00000000000001");
        CardListResponse cardList = cardQueryService.findCardList(user.getUsername(), accountListRequest.getNext_page(), accountListRequest.getLimit());
        return new ResponseEntity<>(cardList, headers, HttpStatus.OK);
    }

    @GetMapping("/{card_id}")
    public ResponseEntity<CardInfoResponse> getCardInfo(
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @PathVariable("card_id") String cardId,
            @Valid @ModelAttribute CardInfoRequest cardInfoRequest)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.add("x-api-tran-id", "1234567890M00000000000001");
        CardInfoResponse cardInfo = cardQueryService.findCardInfo(cardId);
        return new ResponseEntity<>(cardInfo, headers, HttpStatus.OK);
    }

    @GetMapping("/{card_id}/approval-domestic")
    public ResponseEntity<CardTransactionListResponse> getCardTransactionList(
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @PathVariable("card_id") String cardId,
            @Valid @ModelAttribute CardTransactionListRequest cardTransactionListRequest)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.add("x-api-tran-id", "1234567890M00000000000001");
        return new ResponseEntity<>(cardHistoryQueryService.findCardHistory(cardId, cardTransactionListRequest.getNext_page(), cardTransactionListRequest.getLimit()), headers, HttpStatus.OK);
    }

//    @PostMapping("/pay")
//    public ResponseEntity<PayResponse> pay(
//            @AuthenticationPrincipal User user,
//            @RequestBody PayRequest payRequest)
//    {
//        PayResponse pay = cardService.pay(user.getUsername(), payRequest);
//        return new ResponseEntity<>(pay, HttpStatus.OK);
//    }

//    @GetMapping("/recentHistoryId")
//    public ResponseEntity<Long> findLastCardHistoryId() {
//        return ResponseEntity.ok(cardHistoryQueryService.findLastCardHistoryId());
//    }

}
