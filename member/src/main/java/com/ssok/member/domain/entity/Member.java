package com.ssok.member.domain.entity;

import com.ssok.member.global.entity.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@DynamicInsert
@ToString
public class Member extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long memberSeq;

    @Column(name="member_uuid",nullable = false)
    private String memberUuid;

    @Column(name="member_name",nullable = false)
    private String memberName;

    @Column(name="member_id",nullable = false)
    private String memberId;

    @Column(name="member_password",nullable = false)
    private String memberPassword;

    @Column(name="member_simple_password",nullable = false)
    private String memberSimplePassword;

    @Column(name="member_phone",nullable = false)
    private String memberPhone;

    @Column(name="member_ci")
    private String memberCi;

    @Column(name="member_ci_create_date")
    private LocalDateTime memberCiCreateDate;

    @Column(name="member_mydata_access_token", length = 512)
    private String memberMydataAccessToken;

    @Column(name="member_account_num")
    private String memberAccountNum;

    @Column(name="member_is_saving",nullable = false)
    private boolean saving;

    @Column(name="member_is_verification",nullable = false)
    private boolean verification;

    @Column(name="member_is_deleted",nullable = false)
    private boolean deleted;

    @Column(name="member_refresh_token", length = 512)
    private String memberRefreshToken;

    @Column(name="member_service_agreement")
    private boolean serviceAgreement;

    public void updateRefreshToken(String refreshToken){
        this.memberRefreshToken = refreshToken;
    }

    public void updateAccountNum(String memberAccountNum) {
        this.memberAccountNum = memberAccountNum;
    }

    public void updateMydataAccessToken(String memberMydataAccessToken) {
        this.memberMydataAccessToken=memberMydataAccessToken;
    }

    public void changeSaving() {
        this.saving = !this.saving;
    }

    public void changeVerification() {
        this.verification = !this.verification;
    }

    public void deleteRefreshToken() {
        this.memberRefreshToken = null;
    }

    public void agreeService() {
        this.serviceAgreement = true;
    }
}
