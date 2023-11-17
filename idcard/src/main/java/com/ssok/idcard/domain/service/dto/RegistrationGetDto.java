package com.ssok.idcard.domain.service.dto;

import com.ssok.idcard.domain.api.response.RegistrationGetResponse;

import java.time.LocalDate;

public record RegistrationGetDto(
        String registrationCardName,
        String registrationCardPersonalNumber,
        String registrationCardAddress,
        LocalDate registrationCardIssueDate,
        String registrationCardAuthority,
        String registrationCardImage
) {
    public RegistrationGetResponse of(RegistrationGetDto registrationGetDto) {
        return new RegistrationGetResponse(
                registrationGetDto.registrationCardName,
                registrationGetDto.registrationCardPersonalNumber,
                registrationGetDto.registrationCardAddress,
                registrationGetDto.registrationCardIssueDate,
                registrationGetDto.registrationCardAuthority,
                registrationGetDto.registrationCardImage
        );
    }
}
