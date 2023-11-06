package com.ssok.base.domain.maria.entity;

import com.ssok.base.global.entity.BaseEntity;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Donate extends BaseEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "donate_seq")
    private Long donateSeq;

    private Long donateTotalDonation;

    private Integer donateTotalDonator;

    @Column(nullable = false)
    private Boolean donateState;

    @Column(nullable = false)
    private String donateTitle;

    private String donateImage;

    @Builder
    public Donate(Long donateSeq, Long donateTotalDonation, Integer donateTotalDonator, Boolean donateState, String donateTitle, String donateImage) {
        this.donateSeq = donateSeq;
        this.donateTotalDonation = donateTotalDonation;
        this.donateTotalDonator = donateTotalDonator;
        this.donateState = donateState;
        this.donateTitle = donateTitle;
        this.donateImage = donateImage;
    }


    public void updateDonation(Long donateAmt, Boolean isDonateMemberExist) {
        if(!isDonateMemberExist){
            this.donateTotalDonator += 1;
        }
        this.donateTotalDonation += donateAmt;
    }
}
