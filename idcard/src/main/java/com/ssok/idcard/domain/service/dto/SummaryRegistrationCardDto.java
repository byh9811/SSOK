package com.ssok.idcard.domain.service.dto;

import com.ssok.idcard.domain.dao.entity.RegistrationCard;

public record SummaryRegistrationCardDto(
        String registrationCardName,
        String registrationCardPersonalNumber
) {

    public static SummaryRegistrationCardDto from(RegistrationCard registrationCard){
        if(registrationCard == null) return null;
        return new SummaryRegistrationCardDto(
                registrationCard.getRegistrationCardName(),
                registrationCard.getRegistrationCardPersonalNumber()
        );
    }
}
