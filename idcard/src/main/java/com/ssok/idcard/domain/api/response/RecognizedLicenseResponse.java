package com.ssok.idcard.domain.api.response;

import com.ssok.idcard.global.openfeign.naver.dto.response.LicenseOcrResponse;
import lombok.Builder;

import java.time.LocalDate;

import static com.ssok.idcard.global.util.DateUtil.toLocalDate;

@Builder
public record RecognizedLicenseResponse(
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
    public static RecognizedLicenseResponse from(LicenseOcrResponse.DriverLicense license) {

        return RecognizedLicenseResponse.builder()
                .licenseName(license.getName().get(0).getFormatted().getValue())
                .licensePersonalNumber(license.getPersonalNum().get(0).getFormatted().getValue())
                .licenseType(license.getType().get(0).getText())
                .licenseAddress(license.getAddress().get(0).getFormatted().getValue())
                .licenseNumber(license.getNum().get(0).getFormatted().getValue())
                .licenseRenewStartDate(toLocalDate(license.getRenewStartDate().get(0).getFormatted()))
                .licenseRenewEndDate(toLocalDate(license.getRenewEndDate().get(0).getFormatted()))
                .licenseCondition(license.getCondition() != null ? license.getCondition().get(0).getFormatted().getValue() : null)
                .licenseCode(license.getCode().get(0).getFormatted().getValue())
                .licenseIssueDate(toLocalDate(license.getIssueDate().get(0).getFormatted()))
                .licenseAuthority(license.getAuthority().get(0).getFormatted().getValue())
                .build();
    }
}
