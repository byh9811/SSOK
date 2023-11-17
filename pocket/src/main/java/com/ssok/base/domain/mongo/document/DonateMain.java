package com.ssok.base.domain.mongo.document;

import com.ssok.base.domain.maria.entity.Donate;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "donate_main")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class DonateMain {
    @Id
    private Long donateSeq;
    private Long donateTotalDonation;
    private Integer donateTotalDonator;
    private Boolean donateState;
    private String donateTitle;
    private String donateImage;
    private LocalDateTime createDate;
    private LocalDateTime modifyDate;

    @Builder
    public DonateMain(Long donateSeq, Long donateTotalDonation, Integer donateTotalDonator, Boolean donateState, String donateTitle, String donateImage, LocalDateTime createDate, LocalDateTime modifyDate) {
        this.donateSeq = donateSeq;
        this.donateTotalDonation = donateTotalDonation;
        this.donateTotalDonator = donateTotalDonator;
        this.donateState = donateState;
        this.donateTitle = donateTitle;
        this.donateImage = donateImage;
        this.createDate = createDate;
        this.modifyDate = modifyDate;
    }

    static public DonateMain fromDonate(Donate donate){
        return DonateMain.builder()
                .donateSeq(donate.getDonateSeq())
                .donateTotalDonation(donate.getDonateTotalDonation())
                .donateTotalDonator(donate.getDonateTotalDonator())
                .donateState(donate.getDonateState())
                .donateTitle(donate.getDonateTitle())
                .donateImage(donate.getDonateImage())
                .createDate(donate.getCreateDate())
                .modifyDate(donate.getModifyDate())
                .build();
    }

    public void updateDonateMain(Donate donate) {
        this.donateTotalDonation = donate.getDonateTotalDonation();
        this.donateTotalDonator = donate.getDonateTotalDonator();
        this.modifyDate = donate.getModifyDate();
    }
}
