package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.exception.NamecardException;
import com.ssok.namecard.domain.mongo.document.NamecardMainDoc;
import com.ssok.namecard.domain.mongo.repository.NamecardMainDocMongoRepository;
import com.ssok.namecard.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class NamecardQueryService {

    private final NamecardMainDocMongoRepository namecardMainDocMongoRepository;

    public NamecardMainDoc findByMemberSeq(Long memberSeq){
        return namecardMainDocMongoRepository.findByMemberSeq(memberSeq)
                                   .orElseThrow(
                                       () -> new NamecardException(ErrorCode.NAMECARD_NOT_FOUND)
                                   );
    }
    public NamecardMainDoc getNamecardMainDoc(String memberUuid) {
        //todo memberUuid -> memberSeq
        Long memberSeq = Long.parseLong(memberUuid);
        NamecardMainDoc namecardMainDoc = findByMemberSeq(memberSeq);
        log.info("메인페이지 조회: {}", namecardMainDoc);
        return namecardMainDoc;
    }
}
