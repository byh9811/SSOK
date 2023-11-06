package com.ssok.idcard.domain.service.dto;

import com.ssok.idcard.domain.api.request.LicenseCreateRequest;

import java.time.LocalDate;

public record LicenseCreateDto(
        Long memberSeq,
        String licenseName,
        String licensePersonalNumber,
        String licenseType,
        String licenseAddress,
        String licenseNumber,
        LocalDate licenseRenewStartDate,
        LocalDate licenseRenewEndDate,
        String licenseCondition,
        String licenseCode,
        LocalDate licenseIssueDate,
        String licenseAuthority,
        String licenseImage
) {

    public static LicenseCreateDto fromRequest(Long memberSeq, LicenseCreateRequest request) {
        return new LicenseCreateDto(
                memberSeq,
                request.licenseName(),
                request.licensePersonalNumber(),
                request.licenseType(),
                request.licenseAddress(),
                request.licenseNumber(),
                request.licenseRenewStartDate(),
                request.licenseRenewEndDate(),
                request.licenseCondition(),
                request.licenseCode(),
                request.licenseIssueDate(),
                request.licenseAuthority(),
                request.licenseImage()
        );
    }
}
