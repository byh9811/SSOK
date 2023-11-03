package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.mongo.document.NamecardMain.Namecard;
import java.util.List;
import java.util.stream.Collectors;

public record NamecardResponse(
    Long id,              //명함 식별자
    Long memberId,          //회원 식별자
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
    String date
) {
    public NamecardResponse(Namecard namecard){
        this(namecard.getId(), namecard.getMemberId(), namecard.getNamecardName(), namecard.getNamecardImage(), namecard.getNamecardEmail(), namecard.getNamecardCompany(),
            namecard.getNamecardJob(), namecard.getNamecardAddress(), namecard.getNamecardPhone(),
            namecard.getNamecardFax(), namecard.getNamecardWebsite(), namecard.isFavorite(),
            namecard.getExchangeNote(), namecard.getDate());
    }

    public static List<NamecardResponse> toNamecardResponses(List<Namecard> namecards){
        return namecards.stream()
                        .map(namecard -> new NamecardResponse(namecard))
                        .collect(
                            Collectors.toList());
    }
}
