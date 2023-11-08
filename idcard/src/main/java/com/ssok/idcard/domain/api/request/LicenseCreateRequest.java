package com.ssok.idcard.domain.api.request;

import java.time.LocalDate;

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
        String licenseAuthority
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
            String licenseAuthority
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
                licenseAuthority);
    }

}
