package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.mongo.document.NamecardMain.NamecardMongo;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

public record NamecardResponse(
    Long namecardSeq,              //명함 식별자
    Long memberSeq,          //회원 식별자
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
    public NamecardResponse(NamecardMongo namecardMongo){
        this(namecardMongo.getNamecardMongoSeq(), namecardMongo.getMemberSeq(), namecardMongo.getNamecardName(), namecardMongo.getNamecardImage(), namecardMongo.getNamecardEmail(), namecardMongo.getNamecardCompany(),
            namecardMongo.getNamecardJob(), namecardMongo.getNamecardAddress(), namecardMongo.getNamecardPhone(),
            namecardMongo.getNamecardFax(), namecardMongo.getNamecardWebsite(), namecardMongo.isFavorite(),
            namecardMongo.getExchangeNote(), namecardMongo.getDate());
    }

    public static List<NamecardResponse> toNamecardResponses(List<NamecardMongo> namecardMongos){
        return namecardMongos.stream()
                        .map(n -> new NamecardResponse(n))
                        .collect(
                            Collectors.toList());
    }
}
