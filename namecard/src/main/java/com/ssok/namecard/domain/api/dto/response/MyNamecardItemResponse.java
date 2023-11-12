package com.ssok.namecard.domain.api.dto.response;

public record MyNamecardItemResponse(
    Long namecardSeq,
    String namecardName,
    String namecardCompany,
    String namecardJob,
    String namecardImg
) {

}
