package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.maria.entity.Namecard;

public record MyNamecardItemResponse(
    Long namecardSeq,
    String namecardName,
    String namecardCompany,
    String namecardJob,
    String namecardImg
) {
    public MyNamecardItemResponse(Namecard namecard) {
        this(namecard.getNamecardSeq(), namecard.getNamecardName(), namecard.getNamecardCompany(), namecard.getNamecardCompany(), namecard.getNamecardImage());
    }
}
