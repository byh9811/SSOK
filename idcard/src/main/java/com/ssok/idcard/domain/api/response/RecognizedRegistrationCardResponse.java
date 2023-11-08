package com.ssok.idcard.domain.api.response;

import com.ssok.idcard.global.openfeign.naver.dto.response.LicenseOcrResponse;
import com.ssok.idcard.global.util.DateUtil;
import lombok.Builder;

import java.time.LocalDate;

import static com.ssok.idcard.global.util.DateUtil.toLocalDate;

@Builder
public record RecognizedRegistrationCardResponse(
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
    public static RecognizedRegistrationCardResponse from(LicenseOcrResponse.DriverLicense license) {
        return RecognizedRegistrationCardResponse.builder()
                .licenseName(license.getName().getFormatted().getValue())
                .licensePersonalNumber(license.getPersonalNum().getFormatted().getValue())
                .licenseAddress(license.getAddress().getFormatted().getValue())
                .licenseNumber(license.getNum().getFormatted().getValue())
                .licenseRenewStartDate(toLocalDate(license.getRenewStartDate().getFormatted()))
                .licenseRenewEndDate(toLocalDate(license.getRenewEndDate().getFormatted()))
                .licenseCondition(license.getCondition().getFormatted().getValue())
                .licenseCode(license.getCode().getFormatted().getValue())
                .licenseIssueDate(toLocalDate(license.getIssueDate().getFormatted()))
                .licenseAuthority(license.getAuthority().getFormatted().getValue())
                .build();
    }
}
