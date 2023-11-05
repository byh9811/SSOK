package com.ssok.namecard.domain.mongo.document;

import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Id;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "namecard_main")
@Builder
@ToString
@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class NamecardMain {

    @Id
    private Long namecardMainSeq;  //내 명함 id
    private Long memberSeq;
    private String namecardImg;
    private List<NamecardMongo> favorites = new ArrayList<>();
    private List<NamecardMongo> namecards = new ArrayList<>();

    public void addNamecardMongo(NamecardMongo namecardMongo) {
        this.namecards.add(namecardMongo);
    }


    @Getter
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor(access = AccessLevel.PROTECTED)
    @ToString
    public static class NamecardMongo{
        private Long namecardMongoSeq;              //명함 식별자
        private Long memberSeq;          //회원 식별자
        private String namecardName;    //회원 이름
        private String namecardImage;   //명함 이미지
        private String namecardEmail;
        private String namecardCompany;
        private String namecardJob;
        private String namecardAddress;
        private String namecardPhone;
        private String namecardFax;
        private String namecardWebsite;
        private boolean isFavorite;     //즐겨찾기 여부
        private String exchangeNote;
        private LocalDate date;            //명함교환 날짜

        public static NamecardMongo from(Namecard namecardA) {

            return NamecardMongo.builder()
                                .namecardMongoSeq(namecardA.getNamecardSeq())
                                .memberSeq(namecardA.getMemberSeq())
                                .namecardName(namecardA.getNamecardName())
                                .namecardImage(namecardA.getNamecardImage())
                                .namecardEmail(namecardA.getNamecardEmail())
                                .namecardCompany(namecardA.getNamecardCompany())
                                .namecardJob(namecardA.getNamecardJob())
                                .namecardAddress(namecardA.getNamecardAddress())
                                .namecardPhone(namecardA.getNamecardPhone())
                                .namecardFax(namecardA.getNamecardFax())
                                .namecardWebsite(namecardA.getNamecardWebsite())
                                .build();
        }

        public void addExchangeDate(Exchange exchange) {
            this.date = exchange.getCreateDate().toLocalDate();
        }
    }

    public static NamecardMain from(String uploadUrl, Long memberSeq, Long namecardSeq) {

        return NamecardMain.builder()
                           .favorites(new ArrayList<>())
                           .namecardImg(uploadUrl)
                           .memberSeq(memberSeq)
                           .namecards(new ArrayList<>())
                           .namecardMainSeq(namecardSeq)
                           .build();
    }

}
