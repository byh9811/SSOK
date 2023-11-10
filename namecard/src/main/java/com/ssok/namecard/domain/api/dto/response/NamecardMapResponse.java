package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.maria.entity.Exchange;

public record NamecardMapResponse(
    Long exchangeSeq,
    String namecardName,
    String namecardImage,
    String namecardEmail,
    String namecardCompany,
    String namecardJob,
    String namecardAddress,
    String namecardPhone,
    String namecardFax,
    String namecardWebsite,
    boolean isFavorite,
    String exchangeNote,
    Double lat,
    Double lon
) {
    public NamecardMapResponse(Exchange exchange){
        this(exchange.getExchangeSeq(), exchange.getReceiveNamecard().getNamecardName(), exchange.getReceiveNamecard()
                                                .getNamecardImage(), exchange.getReceiveNamecard()
                                                                             .getNamecardEmail(),
            exchange.getReceiveNamecard()
                    .getNamecardCompany(), exchange.getReceiveNamecard()
                                                   .getNamecardJob(), exchange.getReceiveNamecard()
                                                                              .getNamecardAddress(),
            exchange.getReceiveNamecard()
                    .getNamecardPhone(), exchange.getReceiveNamecard()
                                                 .getNamecardFax(), exchange.getReceiveNamecard()
                                                                            .getNamecardWebsite(),
            exchange.getExchangeIsFavorite(), exchange.getExchangeNote(),
            exchange.getExchangeLatitude(), exchange.getExchangeLongitude());

    }
}
