package com.ssok.member.domain.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.time.LocalDateTime;

@Document(collection = "ssok_member")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class MemberDoc {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long memberSeq;

    @Column(name="member_uuid",nullable = false)
    private String memberUUID;

    @Column(name="member_name",nullable = false)
    private String memberName;

    @Column(name="member_id",nullable = false)
    private String memberId;

    @Column(name="member_password",nullable = false)
    private String memberPassword;

    @Column(name="member_phone",nullable = false)
    private String memberPhone;

    @Column(name="member_ci",nullable = false)
    private String memberCi;

    @Column(name="member_ci_create_date",nullable = false)
    private LocalDateTime memberCiCreateDate;

    @Column(name="member_mydata_access_token")
    private String memberMydataAccessToken;

    @Column(name="member_account_num")
    private String memberAccountNum;

    @Column(name="member_is_saving",nullable = false)
    private boolean memberIsSaving;

    @Column(name="member_is_verification",nullable = false)
    private boolean memberIsVerification;

    @Column(name="member_is_deleted",nullable = false)
    private boolean memberIsDeleted;

    @Column(name="member_sec_password",nullable = false)
    private String memberSecPassword;

    @Column(name="member_refresh_token")
    private String memberRefreshToken;
}
