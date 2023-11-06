package com.ssok.idcard.domain.service.dto;

import com.ssok.idcard.domain.api.request.RegistrationCardCreateRequest;

import java.time.LocalDate;

public record RegistrationCreateDto(
        Long memberSeq,
        String registrationCardName,
        String registrationCardPersonalNumber,
        String registrationCardAddress,
        LocalDate registrationCardIssueDate,
        String registrationCardAuthority,
        String registrationCardImage
) {
    public static RegistrationCreateDto fromRequest(Long memberSeq, RegistrationCardCreateRequest request) {
        return new RegistrationCreateDto(
                memberSeq,
                request.registrationCardName(),
                request.registrationCardPersonalNumber(),
                request.registrationCardAddress(),
                request.registrationCardIssueDate(),
                request.registrationCardAuthority(),
                request.registrationCardImage()
        );
    }
}
