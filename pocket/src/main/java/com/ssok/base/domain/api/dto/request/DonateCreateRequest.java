package com.ssok.base.domain.api.dto.request;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DonateCreateRequest {
    private String donateTitle;

    private String donateImage;
    private Boolean donateState;
    @Builder
    public DonateCreateRequest(String donateTitle, String donateImage, Boolean donateState) {
        this.donateTitle = donateTitle;
        this.donateImage = donateImage;
        this.donateState = donateState;
    }
}
