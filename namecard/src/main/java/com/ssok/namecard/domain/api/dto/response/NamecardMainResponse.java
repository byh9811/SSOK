package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.mongo.document.NamecardMain;
import java.util.List;
import lombok.Builder;

@Builder
public record NamecardMainResponse(
    Long namecardSeq,  //내 명함 id
    Long memberSeq,
    String namecardImg,
    List<NamecardResponse>favorites,
    List<NamecardResponse> namecards
) {

    public NamecardMainResponse(NamecardMain namecardMain) {
        this(namecardMain.getNamecardMainSeq(), namecardMain.getMemberSeq(), namecardMain.getNamecardImg(),
            NamecardResponse.toNamecardResponses(namecardMain.getFavorites()),
            NamecardResponse.toNamecardResponses(namecardMain.getNamecards()));
    }
}