package com.ssok.idcard.domain.service.dto;

import com.ssok.idcard.domain.dao.entity.RegistrationCard;

public record SummaryRegistrationCardDto(
        String registrationCardName,
        String registrationCardPersonalNumber
) {

    public static SummaryRegistrationCardDto from(RegistrationCard registrationCard){
        if(registrationCard == null) return null;
        if(registrationCard.getRegistrationCardPersonalNumber().length()<8) return null;
        String maskedPN = registrationCard.getRegistrationCardPersonalNumber().substring(0, 8) + "*".repeat(registrationCard.getRegistrationCardPersonalNumber().length() - 8);
        return new SummaryRegistrationCardDto(
                registrationCard.getRegistrationCardName(),
                maskedPN
        );
    }
}
