package com.ssok.namecard.domain.api.dto.response;

import java.util.List;
import lombok.Builder;

@Builder
public record NamecardMainDocResponse(
    Long memberSeq,
    List<MyNamecardItemResponse> myNamecardItems, //내 명함 목록
    List<MyExchangeItemResponse> myExchangeItems, //교환 목록
    List<MyExchangeItemResponse> favorites //즐겨찾기 목록
) {
}