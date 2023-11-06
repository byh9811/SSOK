package com.ssok.base.domain.api.dto.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DonateCreateRequest {
    private String donateTitle;

    private String donateImage;

    @Builder
    public DonateCreateRequest(String donateTitle, String donateImage) {
        this.donateTitle = donateTitle;
        this.donateImage = donateImage;
    }
}
