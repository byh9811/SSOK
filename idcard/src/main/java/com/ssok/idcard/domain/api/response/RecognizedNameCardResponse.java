package com.ssok.idcard.domain.api.response;

import com.ssok.idcard.global.openfeign.naver.dto.response.LicenseOcrResponse;
import com.ssok.idcard.global.openfeign.naver.dto.response.NameCardOcrResponse;
import lombok.Builder;
import lombok.ToString;

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
        System.out.println("record from method-------------------");
        System.out.println(nameCard.toString());
        return RecognizedNameCardResponse.builder()
                .name(nameCard.getName().get(0).getFormatted().getValue())
                .company(nameCard.getCompany().get(0).getFormatted().getValue())
                .department(nameCard.getAddress().get(0).getFormatted().getValue())
                .address(nameCard.getAddress().get(0).getFormatted().getValue())
                .position(nameCard.getPosition().get(0).getFormatted().getValue())
                .mobile(nameCard.getMobile().get(0).getFormatted().getValue())
                .tel(nameCard.getTel().get(0).getFormatted().getValue())
                .fax(nameCard.getFax().get(0).getFormatted().getValue())
                .email(nameCard.getEmail().get(0).getFormatted().getValue())
                .homepage(nameCard.getHomepage().get(0).getFormatted().getValue())
                .build();
    }
}
