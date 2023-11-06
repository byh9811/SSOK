package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.mongo.document.NamecardMainDoc;
import java.util.List;
import lombok.Builder;

@Builder
public record NamecardMainDocResponse(
    Long namecardSeq,  //내 명함 id
    Long memberSeq,
    String namecardImg,
    List<NamecardResponse> favorites,
    List<NamecardResponse> namecards
) {

    public NamecardMainDocResponse(NamecardMainDoc namecardMainDoc) {
        this(namecardMainDoc.getNamecardSeq(), namecardMainDoc.getMemberSeq(), namecardMainDoc.getNamecardImg(),
            NamecardResponse.toNamecardResponses(namecardMainDoc.getFavorites()),
            NamecardResponse.toNamecardResponses(namecardMainDoc.getNamecards()));
    }
}