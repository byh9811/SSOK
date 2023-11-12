package com.ssok.idcard.domain.api.response;

import com.ssok.idcard.global.openfeign.naver.dto.response.RegistrationCardOcrResponse;
import lombok.Builder;

import java.time.LocalDate;

import static com.ssok.idcard.global.util.DateUtil.toLocalDate;

@Builder
public record RecognizedRegistrationCardResponse(
        String registrationCardName,
        String registrationCardPersonalNumber,
        String registrationCardAddress,
        LocalDate registrationCardIssueDate,
        String registrationCardAuthority
) {

    public static RecognizedRegistrationCardResponse from(RegistrationCardOcrResponse.RegstrationCard regstrationCard) {
        return RecognizedRegistrationCardResponse.builder()
                .registrationCardName(regstrationCard.getName().get(0).getFormatted().getValue())
                .registrationCardPersonalNumber(regstrationCard.getPersonalNum().get(0).getFormatted().getValue())
                .registrationCardAddress(regstrationCard.getAddress().get(0).getFormatted().getValue())
                .registrationCardIssueDate(toLocalDate(regstrationCard.getIssueDate().get(0).getFormatted()))
                .registrationCardAuthority(regstrationCard.getAuthority().get(0).getFormatted().getValue())
                .build();
    }
}
