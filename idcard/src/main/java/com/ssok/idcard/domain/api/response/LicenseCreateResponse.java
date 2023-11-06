package com.ssok.idcard.domain.api.response;

import lombok.Builder;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Builder
public record LicenseCreateResponse(
        Long memberSeq,
        String licenseName,
        String licensePersonalNumber,
        String licenseType,
        String licenseAddress,
        String licenseNumber,
        LocalDate licenseRenewStardDate,
        LocalDate licenseRenewEndDate,
        String licenseCondition,
        String licenseCode,
        LocalDate licenseIssueDate,
        String licenseAuthority,
        String licenseImage
) {

    public static LicenseCreateResponse of(
            Long memberSeq,
            String licenseName,
            String licensePersonalNumber,
            String licenseType,
            String licenseAddress,
            String licenseNumber,
            LocalDate licenseRenewStardDate,
            LocalDate licenseRenewEndDate,
            String licenseCondition,
            String licenseCode,
            LocalDate licenseIssueDate,
            String licenseAuthority,
            String licenseImage
    ){
        return new LicenseCreateResponse(
                memberSeq,
                licenseName,
                licensePersonalNumber,
                licenseType,
                licenseAddress,
                licenseNumber,
                licenseRenewStardDate,
                licenseRenewEndDate,
                licenseCondition,
                licenseCode,
                licenseIssueDate,
                licenseAuthority,
                licenseImage);
    }

}
