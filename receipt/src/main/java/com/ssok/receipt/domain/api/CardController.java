package com.ssok.receipt.domain.api;

import com.ssok.receipt.domain.api.dto.response.CardAdminQueryResponse;
import com.ssok.receipt.domain.api.dto.response.CardHistoryListResponses;
import com.ssok.receipt.domain.api.dto.response.CardQueryResponse;
import com.ssok.receipt.domain.api.dto.response.ReceiptListQueryResponses;
import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.repository.CardRepository;
import com.ssok.receipt.domain.service.CardQueryService;
import com.ssok.receipt.domain.service.CardService;
import com.ssok.receipt.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.YearMonth;
import java.util.Map;

import static com.ssok.receipt.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/receipt-service/card")
@Slf4j
public class CardController {

    private final CardService cardService;
    private final CardQueryService cardQueryService;
    private final CardRepository cardRepository;

    @PostMapping
    public ApiResponse<Void> createCard(
            @RequestHeader("MEMBER-UUID") String memberUUID
    ) {
        cardService.createCard(memberUUID);
        return OK(null);
    }

    @GetMapping
    public ApiResponse<CardQueryResponse> getCard(
            @RequestHeader("MEMBER-UUID") String memberUUID
    ) {
        CardQueryResponse card = cardQueryService.getCard(memberUUID);
        return OK(card);
    }

    @GetMapping("/admin/{member_seq}")
    public ApiResponse<CardAdminQueryResponse> getCardByAdmin(
            @PathVariable("member_seq") Long memberSeq
    ) {
        Card card = cardRepository.findByMemberSeq(memberSeq).get();
        return OK(CardAdminQueryResponse.from(card));
    }

    @GetMapping("/history/list")
    public ApiResponse<Map<YearMonth, CardHistoryListResponses>> getCardHistoryList(
            @RequestHeader("MEMBER-UUID") String memberUUID
    ) {
        Map<YearMonth, CardHistoryListResponses> cardHistoryList = cardQueryService.getCardHistoryList(memberUUID);
        return OK(cardHistoryList);
    }

}
