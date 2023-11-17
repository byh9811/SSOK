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
        return RecognizedNameCardResponse.builder()
                .name(nameCard.getName() == null ? null : nameCard.getName().get(0).getText())
                .company(nameCard.getCompany()== null ? null : nameCard.getCompany().get(0).getText())
                .department(nameCard.getDepartment() == null ? null : nameCard.getDepartment().get(0).getText())
                .address(nameCard.getAddress() == null ? null : nameCard.getAddress().get(0).getText())
                .position(nameCard.getPosition() == null ? null : nameCard.getPosition().get(0).getText())
                .mobile(nameCard.getMobile() == null ? null : nameCard.getMobile().get(0).getText())
                .tel(nameCard.getTel() == null ? null : nameCard.getTel().get(0).getText())
                .fax(nameCard.getFax() == null ? null : nameCard.getFax().get(0).getText())
                .email(nameCard.getEmail() == null ? null : nameCard.getEmail().get(0).getText())
                .homepage(nameCard.getHomepage() == null ? null : nameCard.getHomepage().get(0).getText())
                .build();
    }
}
