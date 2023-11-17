package com.ssok.base.domain.api.dto.response;

import com.ssok.base.domain.mongo.document.DonateMain;
import lombok.Builder;
import lombok.Data;

@Data
public class DonatesResponse {
    private Long donateSeq;
    private Long donateTotalDonation;
    private Integer donateTotalDonator;
    private Boolean donateState;
    private String donateTitle;
    private String donateImage;
    private Long memberTotalDonateAmt;

    @Builder
    public DonatesResponse(Long donateSeq, Long donateTotalDonation, Integer donateTotalDonator, Boolean donateState, String donateTitle, String donateImage, Long memberTotalDonateAmt) {
        this.donateSeq = donateSeq;
        this.donateTotalDonation = donateTotalDonation;
        this.donateTotalDonator = donateTotalDonator;
        this.donateState = donateState;
        this.donateTitle = donateTitle;
        this.donateImage = donateImage;
        this.memberTotalDonateAmt = memberTotalDonateAmt;
    }

    static public DonatesResponse fromDonateMain(DonateMain donateMain, Long memberTotalDonateAmt){
        return DonatesResponse.builder()
                .donateSeq(donateMain.getDonateSeq())
                .donateTotalDonation(donateMain.getDonateTotalDonation())
                .donateTotalDonator(donateMain.getDonateTotalDonator())
                .donateState(donateMain.getDonateState())
                .donateTitle(donateMain.getDonateTitle())
                .donateImage(donateMain.getDonateImage())
                .memberTotalDonateAmt(memberTotalDonateAmt)
                .build();
    }
}
