package com.ssok.namecard.domain.mongo.document;

import com.ssok.namecard.domain.maria.entity.Namecard;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "namecard_main")
@Builder
@ToString
@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class NamecardMainDoc {

    @Id
    private Long memberSeq;
    private Long namecardSeq;  //내 명함 id
    private String namecardImg;
    private List<NamecardDoc> favorites = new ArrayList<>();
    private List<NamecardDoc> namecards = new ArrayList<>();

    public void addNamecardDoc(NamecardDoc namecardDoc) {
        this.namecards.add(namecardDoc);
    }

    public void updateMyNamecard(Namecard namecard) {
        this.namecardSeq = namecard.getNamecardSeq();
        this.namecardImg = namecard.getNamecardImage();
    }


    @Getter
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor(access = AccessLevel.PROTECTED)
    @ToString
    public static class NamecardDoc{
        @Id
        private Long exchangeSeq;        //교환 식별자
        private Long namecardDocSeq;     //명함 식별자
        private Long memberSeq;          //회원 식별자
        private String namecardName;     //회원 이름
        private String namecardImage;    //명함 이미지
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

        public static NamecardDoc from(Namecard namecardA) {

            return NamecardDoc.builder()
                              .namecardDocSeq(namecardA.getNamecardSeq())
                              .memberSeq(namecardA.getMemberSeq())
                              .namecardName(namecardA.getNamecardName())
                              .namecardImage(namecardA.getNamecardImage())
                              .namecardEmail(namecardA.getNamecardEmail())
                              .namecardCompany(namecardA.getNamecardCompany())
                              .namecardJob(namecardA.getNamecardJob())
                              .exchangeNote("")
                              .namecardAddress(namecardA.getNamecardAddress())
                              .namecardPhone(namecardA.getNamecardPhone())
                              .namecardFax(namecardA.getNamecardFax())
                              .namecardWebsite(namecardA.getNamecardWebsite())
                              .build();
        }

        public void addExchangeDate(LocalDate localDate) {
            this.date = localDate;
        }

        public void addExchangeSeq(Long exchangeSeq) {
            this.exchangeSeq = exchangeSeq;
        }

        public void update(String memo){this.exchangeNote = memo;}
    }

    public static NamecardMainDoc from(Namecard namecard) {

        return NamecardMainDoc.builder()
                           .favorites(new ArrayList<>())
                           .namecardImg(namecard.getNamecardImage())
                           .memberSeq(namecard.getMemberSeq())
                           .namecards(new ArrayList<>())
                           .namecardSeq(namecard.getNamecardSeq())
                           .build();
    }

}
