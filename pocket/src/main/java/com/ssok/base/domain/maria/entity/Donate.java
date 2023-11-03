package com.ssok.base.domain.maria.entity;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Donate {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "donate_seq")
    private Long donateSeq;

    private Long donateTotalDonation;

    private Integer donateTotalDonator;

    @Column(nullable = false)
    private Boolean donateState;

    @Column(nullable = false)
    private String donateTitle;

    private String donate_image;

    @Builder
    public Donate(Long donateSeq, Long donateTotalDonation, Integer donateTotalDonator, Boolean donateState, String donateTitle, String donate_image) {
        this.donateSeq = donateSeq;
        this.donateTotalDonation = donateTotalDonation;
        this.donateTotalDonator = donateTotalDonator;
        this.donateState = donateState;
        this.donateTitle = donateTitle;
        this.donate_image = donate_image;
    }
}
