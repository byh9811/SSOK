package com.ssok.idcard.domain.api.request;

import java.time.LocalDate;

import static com.ssok.idcard.global.util.ValidateUtil.PERSONAL_NUMBER_PATTERN;

public record RegistrationCardCreateRequest(
        String registrationCardName,
        String registrationCardPersonalNumber,
        String registrationCardAddress,
        LocalDate registrationCardIssueDate,
        String registrationCardAuthority
) {

    public RegistrationCardCreateRequest {
        if (!PERSONAL_NUMBER_PATTERN.matcher(registrationCardPersonalNumber).matches()) {
            throw new IllegalArgumentException("Personal number must be in the format XXXXXX-XXXXXXX");
        }
    }

}
