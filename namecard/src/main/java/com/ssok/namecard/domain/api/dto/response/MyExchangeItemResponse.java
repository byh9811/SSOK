package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import com.ssok.namecard.domain.maria.entity.UpdateStatus;

public record MyExchangeItemResponse(
    Long exchangeSeq,
    Long namecardSeq,
    Long belongNamecardSeq,
    String name,
    UpdateStatus updateStatus,
    String company,
    String job,
    String exchangeDate,
    Boolean isFavorite
) {
    public MyExchangeItemResponse(Exchange exchange) {
        this(exchange, exchange.getReceiveNamecard(), exchange.getSendNamecard());
    }
    public MyExchangeItemResponse(Exchange exchange, Namecard receiveNamecard, Namecard sendNamecard){
        this(exchange.getExchangeSeq(), receiveNamecard.getNamecardSeq(), sendNamecard.getNamecardSeq(), receiveNamecard.getNamecardName(), exchange.getUpdateStatus(), receiveNamecard.getNamecardCompany(),
            receiveNamecard.getNamecardJob(), exchange.getCreateDate().toLocalDate().toString(), exchange.getExchangeIsFavorite());
    }
}
