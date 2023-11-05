package com.ssok.namecard.domain.api.dto.request;

import javax.validation.constraints.NotNull;

public record ExchangeSingleRequest(
    @NotNull Long namecardASeq,
    @NotNull Long namecardBSeq,
    @NotNull Double lat,
    @NotNull Double lon
) {

}
//35.193844!4d126.8102029!