package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.mongo.document.NamecardDetailDoc;
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
    String namecardJob,
    String namecardAddress,
    String namecardPhone,
    String namecardFax,
    String namecardWebsite,
    Double lat,
    Double lon
){

    public static NamecardDetailDocResponse from(NamecardDetailDoc namecardDetailDoc) {
        return NamecardDetailDocResponse.builder()
                                        .exchangeSeq(namecardDetailDoc.getExchangeSeq())
                                        .namecardImage(namecardDetailDoc.getNamecardImage())
                                        .memberSeq(namecardDetailDoc.getMemberSeq())
                                        .namecardName(namecardDetailDoc.getNamecardName())
                                        .namecardEmail(namecardDetailDoc.getNamecardEmail())
                                        .namecardCompany(namecardDetailDoc.getNamecardCompany())
                                        .namecardJob(namecardDetailDoc.getNamecardJob())
                                        .namecardAddress(namecardDetailDoc.getNamecardAddress())
                                        .namecardPhone(namecardDetailDoc.getNamecardPhone())
                                        .namecardFax(namecardDetailDoc.getNamecardFax())
                                        .namecardWebsite(namecardDetailDoc.getNamecardWebsite())
                                        .lat(namecardDetailDoc.getLat())
                                        .lon(namecardDetailDoc.getLon())
                                        .build();
    }
}
