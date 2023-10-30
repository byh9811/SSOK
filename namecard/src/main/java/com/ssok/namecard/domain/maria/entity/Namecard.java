package com.ssok.namecard.domain.maria.entity;

import com.ssok.namecard.domain.service.dto.NamecardCreateRequest;
import com.ssok.namecard.global.entity.BaseEntity;
import javax.persistence.Column;
import javax.persistence.Entity;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
public class Namecard extends BaseEntity {

    private Long memberId;
    private String namecardName;
    private String namecardImage;
    private String namecardEmail;
    private String namecardCompany;
    private String namecardJob;
    private String namecardAddress;
    private String namecardPhone;
    private String namecardFax;
    private String namecardWebsite;

    public static Namecard fromRequest(NamecardCreateRequest namecardCreateRequest){
        return Namecard.builder()
                       .memberId(namecardCreateRequest.memberId())
                       .namecardName(namecardCreateRequest.namecardName())
                       .namecardImage(namecardCreateRequest.namecardImage())
                       .namecardEmail(namecardCreateRequest.namecardEmail())
                       .namecardCompany(namecardCreateRequest.namecardCompany())
                       .namecardJob(namecardCreateRequest.namecardJob())
                       .namecardAddress(namecardCreateRequest.namecardAddress())
                       .namecardPhone(namecardCreateRequest.namecardPhone())
                       .namecardFax(namecardCreateRequest.namecardFax())
                       .namecardWebsite(namecardCreateRequest.namecardWebsite())
                       .build();
    }
}
