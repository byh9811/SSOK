package com.ssok.namecard.domain.maria.entity;

import com.ssok.namecard.domain.service.dto.NamecardCreateRequest;
import com.ssok.namecard.global.entity.BaseEntity;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
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

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long namecardSeq;
    private Long memberSeq;
    private String namecardName;
    private String namecardImage;
    private String namecardEmail;
    private String namecardCompany;
    private String namecardJob;
    private String namecardAddress;
    private String namecardPhone;
    private String namecardFax;
    private String namecardWebsite;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "sendNamecard")
    private List<Exchange> exchanges = new ArrayList<>();



    public static Namecard from(NamecardCreateRequest namecardCreateRequest, Long memberSeq,
        String uploadUrl) {

        return Namecard.builder()
                       .memberSeq(memberSeq)
                       .namecardName(namecardCreateRequest.namecardName())
                       .namecardImage(uploadUrl)
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
