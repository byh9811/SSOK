package com.ssok.idcard.domain.api.response;

import java.time.LocalDate;

public record RegistrationGetResponse(
        String registrationCardName,
        String registrationCardPersonalNumber,
        String registrationCardAddress,
        LocalDate registrationCardIssueDate,
        String registrationCardAuthority,
        String registrationCardImage) {
    public static RegistrationGetResponse of(
            String registrationCardName,
            String registrationCardPersonalNumber,
            String registrationCardAddress,
            LocalDate registrationCardIssueDate,
            String registrationCardAuthority,
            String registrationCardImage
    ){
        return new RegistrationGetResponse(
                registrationCardName,
                registrationCardPersonalNumber,
                registrationCardAddress,
                registrationCardIssueDate,
                registrationCardAuthority,
                registrationCardImage
        );
    }
}
