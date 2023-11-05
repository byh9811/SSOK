package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.exception.NamecardMongoException;
import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import com.ssok.namecard.domain.mongo.document.NamecardMain;
import com.ssok.namecard.domain.mongo.document.NamecardMain.NamecardMongo;
import com.ssok.namecard.domain.mongo.repository.NamecardMainMongoRepository;
import com.ssok.namecard.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
@Slf4j
public class NamecardEventHandler {

    private final NamecardMainMongoRepository namecardMainMongoRepository;
    //다른 화면에 대한 repository 추가해야됨
    //다른 화면에 대한 repository 추가해야됨
    //다른 화면에 대한 repository 추가해야됨

    public NamecardMain findById(Long id){
        return namecardMainMongoRepository.findById(id)
                                   .orElseThrow(
                                       () -> new NamecardMongoException(ErrorCode.MONGO_NAMECARD_NOT_FOUND)
                                   );
    }

    public void createNamecard(String uploadUrl, Long memberSeq, Long namecardSeq) {
        NamecardMain namecardMain = NamecardMain.from(uploadUrl, memberSeq, namecardSeq);
        namecardMainMongoRepository.save(namecardMain);
    }


    @Transactional
    public void exchangeNamecard(Namecard namecardA, Namecard namecardB, Exchange exchangeA,
        Exchange exchangeB) {

        NamecardMain namecardMainA = findById(namecardA.getNamecardSeq());
        NamecardMain namecardMainB = findById(namecardB.getNamecardSeq());

        NamecardMongo namecardMongoA = NamecardMongo.from(namecardA);
        NamecardMongo namecardMongoB = NamecardMongo.from(namecardB);

        namecardMongoA.addExchangeDate(exchangeA);
        namecardMongoB.addExchangeDate(exchangeB);

        namecardMainA.addNamecardMongo(namecardMongoB);
        namecardMainB.addNamecardMongo(namecardMongoA);

        namecardMainMongoRepository.save(namecardMainA);
        namecardMainMongoRepository.save(namecardMainB);

        log.info("{}", namecardMainA);
        log.info("{}", namecardMainB);

    }
}
