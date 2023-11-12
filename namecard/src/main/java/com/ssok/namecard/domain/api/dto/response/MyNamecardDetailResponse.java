package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.maria.entity.Namecard;

public record MyNamecardDetailResponse(
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
    String namecardWebsite
) {

    public MyNamecardDetailResponse(Namecard myNamecard) {
        this(myNamecard.getNamecardImage(),
            myNamecard.getMemberSeq(),
            myNamecard.getNamecardSeq(), myNamecard.getNamecardName(),
            myNamecard.getNamecardEmail(), myNamecard.getNamecardCompany(),
            myNamecard.getNamecardTel(), myNamecard.getNamecardJob(),
            myNamecard.getNamecardAddress(), myNamecard.getNamecardPhone(),
            myNamecard.getNamecardFax(), myNamecard.getNamecardWebsite());
    }
}
