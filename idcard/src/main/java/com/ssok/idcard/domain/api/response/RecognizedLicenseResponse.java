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
                .licenseName(license.getName() != null ?license.getName().get(0).getFormatted().getValue(): null)
                .licensePersonalNumber(license.getPersonalNum() != null ?license.getPersonalNum().get(0).getFormatted().getValue(): null)
                .licenseType(license.getType() != null ?license.getType().get(0).getText(): null)
                .licenseAddress(license.getAddress() != null ? license.getAddress().get(0).getFormatted().getValue(): null)
                .licenseNumber(license.getName() != null ? license.getNum().get(0).getFormatted().getValue(): null)
                .licenseRenewStartDate(license.getRenewStartDate() != null ? toLocalDate(license.getRenewStartDate().get(0).getFormatted()): null)
                .licenseRenewEndDate(license.getRenewEndDate() != null ? toLocalDate(license.getRenewEndDate().get(0).getFormatted()): null)
                .licenseCondition(license.getCondition() != null ? license.getCondition().get(0).getFormatted().getValue() : null)
                .licenseCode(license.getCode() != null ?license.getCode().get(0).getFormatted().getValue(): null)
                .licenseIssueDate(license.getIssueDate() != null ? toLocalDate(license.getIssueDate().get(0).getFormatted()): null)
                .licenseAuthority(license.getAuthority() != null ? license.getAuthority().get(0).getFormatted().getValue(): null)
                .build();
    }
}
