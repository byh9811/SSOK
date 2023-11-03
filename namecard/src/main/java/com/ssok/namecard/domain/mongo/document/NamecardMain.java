package com.ssok.namecard.domain.mongo.document;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.Id;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "namecard_main")
@Builder
@ToString
@Getter
public class NamecardMain {

    @Id
    private Long id;  //내 명함 id
    private Long memberId;
    private String namecardImg;
    private List<Namecard> favorites;
    private List<Namecard> namecards;

    @Getter
    public static class Namecard{
        private Long id;              //명함 식별자
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

    public static NamecardMain from(String uploadUrl, Long memberId, Long namecardId) {

        return NamecardMain.builder()
                           .favorites(new ArrayList<>())
                           .namecardImg(uploadUrl)
                           .memberId(memberId)
                           .namecards(new ArrayList<>())
                           .id(namecardId)
                           .build();
    }

}
