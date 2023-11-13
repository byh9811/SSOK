package com.ssok.idcard.domain.api.request;

import java.time.LocalDate;
import java.util.regex.Pattern;

import static com.ssok.idcard.global.util.ValidateUtil.PERSONAL_NUMBER_PATTERN;

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

    public LicenseCreateRequest {
        if (!PERSONAL_NUMBER_PATTERN.matcher(licensePersonalNumber).matches()) {
            throw new IllegalArgumentException("Personal number must be in the format XXXXXX-XXXXXXX");
        }
    }

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
