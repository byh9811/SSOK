package com.ssok.idcard.domain.service.dto;

import com.ssok.idcard.domain.dao.entity.License;

public record SummaryLicenseDto(
        String licenseName,
        String licensePersonalNumber
) {

    public static SummaryLicenseDto from(License license){
        if(license == null) return null;
        return new SummaryLicenseDto(
                license.getLicenseName(),
                license.getLicensePersonalNumber()
        );
    }
}
