package com.ssok.receipt.domain.api.dto.response;

import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.entity.CardCompany;
import lombok.Builder;

import javax.persistence.*;

@Builder
public record CardAdminQueryResponse(

        String company,
        String cardId,

        String cardNum,

        String cardExpMonth,

        String cardExpYear

) {

    public static CardAdminQueryResponse from(Card card) {
        return CardAdminQueryResponse.builder()
                .cardId(card.getCardId())
                .company(card.getCompany().getCardCompanyName())
                .cardNum(card.getCardNum())
                .cardExpMonth(card.getCardExpMonth())
                .cardExpYear(card.getCardExpYear())
                .build();
    }

}