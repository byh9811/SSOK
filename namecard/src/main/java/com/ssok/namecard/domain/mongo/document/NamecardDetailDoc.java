package com.ssok.namecard.domain.mongo.document;

import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import javax.persistence.Id;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "namecard_detail")
@Builder
@ToString
@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class NamecardDetailDoc {

    @Id
    private Long exchangeSeq;
    private String namecardImage;

    /* 사람 정보 */
    private Long memberSeq;
    private Long namecardSeq;
    private String namecardName;
    private String namecardEmail;
    private String namecardCompany;
    private String namecardJob;
    private String namecardAddress;
    private String namecardPhone;
    private String namecardFax;
    private String namecardWebsite;

    /* 교환 위치 */
    private Double lat;
    private Double lon;

    public static NamecardDetailDoc from(Namecard namecard, Exchange exchange) {
        return NamecardDetailDoc.builder()
                                .exchangeSeq(exchange.getExchangeSeq())
                                .namecardImage(namecard.getNamecardImage())
                                .memberSeq(namecard.getMemberSeq())
                                .namecardSeq(namecard.getNamecardSeq())
                                .namecardEmail(namecard.getNamecardEmail())
                                .namecardName(namecard.getNamecardName())
                                .namecardCompany(namecard.getNamecardCompany())
                                .namecardJob(namecard.getNamecardJob())
                                .namecardAddress(namecard.getNamecardAddress())
                                .namecardPhone(namecard.getNamecardPhone())
                                .namecardFax(namecard.getNamecardFax())
                                .namecardWebsite(namecard.getNamecardWebsite())
                                .lat(exchange.getExchangeLatitude())
                                .lon(exchange.getExchangeLongitude())
                                .build();
    }
}
