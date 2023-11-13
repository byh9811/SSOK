package com.ssok.idcard.domain.service.dto;

import com.ssok.idcard.domain.dao.entity.License;

public record SummaryLicenseDto(
        String licenseName,
        String licensePersonalNumber
) {

    public static SummaryLicenseDto from(License license){
        if(license == null) return null;
        if(license.getLicensePersonalNumber().length()<8) return null;
        String maskedPN = license.getLicensePersonalNumber().substring(0, 8) + "*".repeat(license.getLicensePersonalNumber().length() - 8);
        return new SummaryLicenseDto(
                license.getLicenseName(),
                maskedPN
        );
    }
}
