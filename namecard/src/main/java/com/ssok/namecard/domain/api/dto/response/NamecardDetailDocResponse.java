package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import lombok.Builder;

@Builder
public record NamecardDetailDocResponse(
    Long exchangeSeq,
    String namecardImage,
    Long memberSeq,
    Long namecardSeq,
    String namecardName,
    String namecardEmail,
    String namecardCompany,
    String namecardTel,
    String namecardJob,
    String namecardAddress,
    String namecardPhone,
    String namecardFax,
    String namecardWebsite,
    Double lat,
    Double lon
){

    public NamecardDetailDocResponse(Exchange exchange, Namecard receiveNamecard) {
        this(exchange.getExchangeSeq(), receiveNamecard.getNamecardImage(),
            receiveNamecard.getMemberSeq(),
            receiveNamecard.getNamecardSeq(), receiveNamecard.getNamecardName(),
            receiveNamecard.getNamecardEmail(), receiveNamecard.getNamecardCompany(),
            receiveNamecard.getNamecardTel(), receiveNamecard.getNamecardJob(),
            receiveNamecard.getNamecardAddress(), receiveNamecard.getNamecardPhone(),
            receiveNamecard.getNamecardFax(), receiveNamecard.getNamecardWebsite(),
            exchange.getExchangeLatitude(), exchange.getExchangeLongitude());

    }
}
