package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.api.dto.request.ExchangeSingleRequest;
import com.ssok.namecard.domain.mongo.document.NamecardMain;
import com.ssok.namecard.domain.mongo.repository.NamecardMainMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class NamecardEventHandler {

    private final NamecardMainMongoRepository namecardMainMongoRepository;
    //다른 화면에 대한 repository 추가해야됨
    //다른 화면에 대한 repository 추가해야됨
    //다른 화면에 대한 repository 추가해야됨

    public void createNamecard(String uploadUrl, Long memberId, Long namecardId) {
        NamecardMain namecardMain = NamecardMain.from(uploadUrl, memberId, namecardId);
        namecardMainMongoRepository.save(namecardMain);
    }
    public void exchangeNamecard(ExchangeSingleRequest exchangeSingleRequest) {

    }

}
