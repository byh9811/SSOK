package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.maria.entity.Exchange;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

public record NamecardSearchResponse(
    LocalDate date,
    String name,
    String company,
    String job,
    String imageUrl,
    boolean isMemo,
    boolean isFavorite
) {

    public static List<NamecardSearchResponse> from(List<Exchange> exchangeList) {
        return exchangeList.stream()
                    .map(
                        exchange -> new NamecardSearchResponse(
                            exchange.getCreateDate()
                                    .toLocalDate(),
                            exchange.getReceiveNamecard()
                                    .getNamecardName(),
                            exchange.getReceiveNamecard()
                                    .getNamecardCompany(),
                            exchange.getReceiveNamecard()
                                    .getNamecardJob(),
                            exchange.getReceiveNamecard()
                                    .getNamecardImage(),
                            !exchange.getExchangeNote()
                                     .equals(""),
                            exchange.getExchangeIsFavorite()))
                    .collect(Collectors.toList());
    }
}
