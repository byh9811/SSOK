package com.ssok.receipt.domain.api.dto.response;

import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record CardQueryResponse(
        String cardName,
        String ownerName,
        String cardNum
) {

    public static CardQueryResponse from(Card card, String ownerName) {
        return CardQueryResponse.builder()
                .cardName(card.getCardName())
                .ownerName(ownerName)
                .cardNum(card.getCardNum())
                .build();
    }

}