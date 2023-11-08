package com.ssok.idcard.domain.api.response;

import lombok.Builder;

import java.time.LocalDate;

@Builder
public record RecognizedRegistrationCardResponse(
        String registrationCardName,
        String registrationCardPersonalNumber,
        String registrationCardAddress,
        LocalDate registrationCardIssueDate,
        String registrationCardAuthority,
        String registrationCardImage
) {

}
