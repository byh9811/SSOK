package com.ssok.namecard.domain.service.dto;

public record NamecardCreateRequest(
    String namecardName,
    String namecardEmail,
    String namecardCompany,
    String namecardJob,
    String namecardAddress,
    String namecardPhone,
    String namecardFax,
    String namecardWebsite
) {

}
