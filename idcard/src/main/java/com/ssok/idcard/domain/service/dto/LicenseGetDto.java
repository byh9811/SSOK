package com.ssok.idcard.domain.service.dto;

import com.ssok.idcard.domain.api.response.LicenseGetResponse;

import java.time.LocalDate;

public record LicenseGetDto(
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
    public LicenseGetResponse of(LicenseGetDto licenseGetDto) {
        return new LicenseGetResponse(
                licenseGetDto.licenseName,
                licenseGetDto.licensePersonalNumber,
                licenseGetDto.licenseType,
                licenseGetDto.licenseAddress,
                licenseGetDto.licenseNumber,
                licenseGetDto.licenseRenewStartDate,
                licenseGetDto.licenseRenewEndDate,
                licenseGetDto.licenseCondition,
                licenseGetDto.licenseCode,
                licenseGetDto.licenseIssueDate,
                licenseGetDto.licenseAuthority,
                licenseGetDto.licenseImage
        );
    }
}
