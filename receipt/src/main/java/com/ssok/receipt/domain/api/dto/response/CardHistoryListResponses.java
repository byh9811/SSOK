package com.ssok.receipt.domain.api.dto.response;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Builder
public record CardHistoryListResponses(
        Integer totalHistory,
        Long totalPay,
        List<CardHistoryListResponse> cardHistoryListResponses
) {

    public static CardHistoryListResponses from(Integer totalHistory, Long totalPay, List<CardHistoryListResponse> cardHistoryListResponseList) {
        return CardHistoryListResponses.builder()
                .totalHistory(totalHistory)
                .totalPay(totalPay)
                .cardHistoryListResponses(cardHistoryListResponseList)
                .build();
    }

}

