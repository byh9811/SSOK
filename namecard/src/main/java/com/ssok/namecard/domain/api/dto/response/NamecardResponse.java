package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import com.ssok.namecard.domain.mongo.document.NamecardMainDoc.NamecardDoc;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

public record NamecardResponse(
    Long namecardSeq,              //명함 식별자
    Long memberSeq,          //회원 식별자
    Long exchangeSeq,
    String namecardName,    //회원 이름
    String namecardImage,   //명함 이미지
    String namecardEmail,
    String namecardCompany,
    String namecardJob,
    String namecardAddress,
    String namecardPhone,
    String namecardFax,
    String namecardWebsite,
    boolean isFavorite,     //즐겨찾기 여부
    String exchangeNote,
    LocalDate date
) {
    public NamecardResponse(NamecardDoc namecardDoc){
        this(namecardDoc.getNamecardDocSeq(), namecardDoc.getMemberSeq(),
            namecardDoc.getExchangeSeq(), namecardDoc.getNamecardName(),
            namecardDoc.getNamecardImage(), namecardDoc.getNamecardEmail(),
            namecardDoc.getNamecardCompany(), namecardDoc.getNamecardJob(),
            namecardDoc.getNamecardAddress(), namecardDoc.getNamecardPhone(),
            namecardDoc.getNamecardFax(), namecardDoc.getNamecardWebsite(),
            namecardDoc.isFavorite(), namecardDoc.getExchangeNote(),
            namecardDoc.getDate());
    }

    public NamecardResponse(Namecard latestNamecard, Exchange exchange) {
        this(latestNamecard.getNamecardSeq(), latestNamecard.getMemberSeq(),
            exchange.getExchangeSeq(), latestNamecard.getNamecardName(),
            latestNamecard.getNamecardImage(), latestNamecard.getNamecardEmail(),
            latestNamecard.getNamecardCompany(), latestNamecard.getNamecardJob(),
            latestNamecard.getNamecardAddress(), latestNamecard.getNamecardPhone(),
            latestNamecard.getNamecardFax(), latestNamecard.getNamecardWebsite(),
            exchange.getExchangeIsFavorite(), exchange.getExchangeNote(),
            exchange.getCreateDate().toLocalDate());
    }

    public static List<NamecardResponse> toNamecardResponses(List<NamecardDoc> namecardDocs){
        return namecardDocs.stream()
                        .map(n -> new NamecardResponse(n))
                        .collect(
                            Collectors.toList());
    }
}
