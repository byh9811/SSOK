package com.ssok.namecard.domain.mongo.document;

import java.util.List;
import javax.persistence.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "namecard_main")
public class NamecardMain {

    @Id
    private String id;  //내 명함 id
    private Long memberId;
    private String namecardImg;
    private List<Namecard> favorites;
    private List<Namecard> namecards;
    private String LocalDate;

    public static class Namecard{
        @Id
        private String id;              //명함 식별자
        private Long memberId;          //회원 식별자
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
        private String date;            //명함교환 날짜

    }

}
