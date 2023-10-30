package com.ssok.namecard.domain.service.dto;

public record NamecardCreateRequest(
    Long memberId,
    String namecardName,
    String namecardImage,
    String namecardEmail,
    String namecardCompany,
    String namecardJob,
    String namecardAddress,
    String namecardPhone,
    String namecardFax,
    String namecardWebsite
) {

}
