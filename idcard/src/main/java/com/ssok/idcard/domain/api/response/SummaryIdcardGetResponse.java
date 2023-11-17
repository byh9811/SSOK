package com.ssok.idcard.domain.api.response;

import com.ssok.idcard.domain.service.dto.SummaryLicenseDto;
import com.ssok.idcard.domain.service.dto.SummaryRegistrationCardDto;

public record SummaryIdcardGetResponse(
        SummaryRegistrationCardDto summaryRegistrationCard,
        SummaryLicenseDto summaryLicense
) {
    public SummaryIdcardGetResponse fromDTO(SummaryRegistrationCardDto summaryRegistrationCardDto,
                                    SummaryLicenseDto summaryLicenseDto){
        return new SummaryIdcardGetResponse(summaryRegistrationCardDto, summaryLicenseDto);
    }

}
