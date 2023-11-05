package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.exception.NamecardDocException;
import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import com.ssok.namecard.domain.mongo.document.NamecardMainDoc;
import com.ssok.namecard.domain.mongo.document.NamecardMainDoc.NamecardDoc;
import com.ssok.namecard.domain.mongo.repository.NamecardMainDocMongoRepository;
import com.ssok.namecard.global.exception.ErrorCode;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
@Slf4j
public class NamecardEventHandler {

    private final NamecardMainDocMongoRepository namecardMainDocMongoRepository;
    //다른 화면에 대한 repository 추가해야됨
    //다른 화면에 대한 repository 추가해야됨
    //다른 화면에 대한 repository 추가해야됨

    public NamecardMainDoc findBySeq(Long seq){
        return namecardMainDocMongoRepository.findByMemberSeq(seq)
                                   .orElseThrow(
                                       () -> new NamecardDocException(ErrorCode.MONGO_NAMECARD_NOT_FOUND)
                                   );
    }

    public void createNamecard(Namecard namecard) {
        NamecardMainDoc namecardMainDoc = NamecardMainDoc.from(namecard);
        namecardMainDocMongoRepository.save(namecardMainDoc);
    }


    @Transactional
    public void exchangeNamecard(Namecard namecardA, Namecard namecardB, List<Exchange> exchangeList) {

        /* A에게 보여질 명함 메인*/
        NamecardMainDoc namecardMainDocA = findBySeq(namecardA.getNamecardSeq());

        /* B에게 보여질 명함 메인*/
        NamecardMainDoc namecardMainDocB = findBySeq(namecardB.getNamecardSeq());

        NamecardDoc namecardDocA = NamecardDoc.from(namecardA);  //B 친구 명함 목록에 들어갈 A명함
        NamecardDoc namecardDocB = NamecardDoc.from(namecardB); //A 친구 명함 목록에 들어갈 B명함

        namecardDocA.addExchangeDate(exchangeList.get(0).getCreateDate().toLocalDate());
        namecardDocB.addExchangeDate(exchangeList.get(1).getCreateDate().toLocalDate());

        namecardMainDocA.addNamecardDoc(namecardDocB);
        namecardMainDocB.addNamecardDoc(namecardDocA);

        namecardMainDocMongoRepository.save(namecardMainDocA);
        namecardMainDocMongoRepository.save(namecardMainDocB);

        log.info("A의 명함 메인: {}", namecardMainDocA);
        log.info("B의 명함 메인: {}", namecardMainDocB);

    }
}
