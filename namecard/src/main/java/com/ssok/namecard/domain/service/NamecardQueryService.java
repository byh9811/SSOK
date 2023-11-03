package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.mongo.document.NamecardMain;
import com.ssok.namecard.domain.mongo.repository.NamecardMainMongoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class NamecardQueryService {

    private final NamecardMainMongoRepository namecardMainMongoRepository;

    public NamecardMain getNamecardMain(String memberUuid) {
        //todo memberUuid -> memberSeq
        Long memberId = 1L;
        NamecardMain byMemberId = namecardMainMongoRepository.findByMemberId(memberId);
        log.info("{}", byMemberId);
        return namecardMainMongoRepository.findByMemberId(memberId);
    }
}
