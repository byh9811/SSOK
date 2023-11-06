package com.ssok.receipt.domain.api;

import com.ssok.receipt.domain.api.dto.response.CardQueryResponse;
import com.ssok.receipt.domain.service.CardQueryService;
import com.ssok.receipt.domain.service.CardService;
import com.ssok.receipt.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/receipt-service/card")
@Slf4j
public class CardController {

    private final CardService cardService;
    private final CardQueryService cardQueryService;

    @PostMapping
    public ApiResponse<Void> createCard(
            @RequestHeader("MEMBER-UUID") String memberUUID
    ) {
        cardService.createCard(memberUUID);
        return ApiResponse.OK(null);
    }

    @GetMapping
    public ApiResponse<CardQueryResponse> getCard(
            @RequestHeader("MEMBER-UUID") String memberUUID
    ) {
        CardQueryResponse card = cardQueryService.getCard(memberUUID);
        return ApiResponse.OK(card);
    }
}
