package com.ssok.namecard.domain.api.dto.response;

import com.ssok.namecard.domain.maria.entity.Namecard;

public record TimeLineResponse(
    String date,
    String imgUrl
) {

    public TimeLineResponse(Namecard namecard) {
        this(namecard.getCreateDate().toLocalDate().toString(), namecard.getNamecardImage());
    }
}
