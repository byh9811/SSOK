package com.ssok.idcard.domain.api.request;

import com.ssok.idcard.domain.api.response.LicenseCreateResponse;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record LicenseCreateRequest(
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
    public static LicenseCreateRequest of(
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
    ){
        return new LicenseCreateRequest(
                licenseName,
                licensePersonalNumber,
                licenseType,
                licenseAddress,
                licenseNumber,
                licenseRenewStartDate,
                licenseRenewEndDate,
                licenseCondition,
                licenseCode,
                licenseIssueDate,
                licenseAuthority,
                licenseImage);
    }

}
