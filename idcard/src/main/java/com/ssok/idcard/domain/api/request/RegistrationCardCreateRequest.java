package com.ssok.idcard.domain.api.request;

import java.time.LocalDate;

public record RegistrationCardCreateRequest(
        String registrationCardName,
        String registrationCardPersonalNumber,
        String registrationCardAddress,
        LocalDate registrationCardIssueDate,
        String registrationCardAuthority
) {
}
