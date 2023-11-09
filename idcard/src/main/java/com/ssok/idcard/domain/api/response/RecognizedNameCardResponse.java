package com.ssok.idcard.domain.api.response;

import com.ssok.idcard.global.openfeign.naver.dto.response.LicenseOcrResponse;
import com.ssok.idcard.global.openfeign.naver.dto.response.NameCardOcrResponse;
import lombok.Builder;

import java.time.LocalDate;

import static com.ssok.idcard.global.util.DateUtil.toLocalDate;

@Builder
public record RecognizedNameCardResponse(
        String name,
        String company,
        String department,
        String address,
        String position,
        String mobile,
        String tel,
        String fax,
        String email,
        String homepage
) {
    public static RecognizedNameCardResponse from(NameCardOcrResponse.Result nameCard) {
        return RecognizedNameCardResponse.builder()
                .name(nameCard.getName().getFormatted().getValue())
                .company(nameCard.getCompany().getFormatted().getValue())
                .department(nameCard.getAddress().getFormatted().getValue())
                .address(nameCard.getAddress().getFormatted().getValue())
                .position(nameCard.getPosition().getFormatted().getValue())
                .mobile(nameCard.getMobile().getFormatted().getValue())
                .tel(nameCard.getTel().getFormatted().getValue())
                .fax(nameCard.getFax().getFormatted().getValue())
                .email(nameCard.getEmail().getFormatted().getValue())
                .homepage(nameCard.getHomepage().getFormatted().getValue())
                .build();
    }
}
