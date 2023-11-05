package com.ssok.base.domain.mongo.document;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.persistence.Id;
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
    private String donate_image;
    private LocalDateTime createDate;
    private LocalDateTime modifyDate;

    @Builder
    public DonateMain(Long donateSeq, Long donateTotalDonation, Integer donateTotalDonator, Boolean donateState, String donateTitle, String donate_image, LocalDateTime createDate, LocalDateTime modifyDate) {
        this.donateSeq = donateSeq;
        this.donateTotalDonation = donateTotalDonation;
        this.donateTotalDonator = donateTotalDonator;
        this.donateState = donateState;
        this.donateTitle = donateTitle;
        this.donate_image = donate_image;
        this.createDate = createDate;
        this.modifyDate = modifyDate;
    }
}
