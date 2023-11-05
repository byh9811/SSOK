package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.exception.NamecardException;
import com.ssok.namecard.domain.mongo.document.NamecardMain;
import com.ssok.namecard.domain.mongo.repository.NamecardMainMongoRepository;
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

    private final NamecardMainMongoRepository namecardMainMongoRepository;

    public NamecardMain findByMemberSeq(Long id){
        return namecardMainMongoRepository.findByMemberSeq(id)
                                   .orElseThrow(
                                       () -> new NamecardException(ErrorCode.NAMECARD_NOT_FOUND)
                                   );
    }
    public NamecardMain getNamecardMain(String memberUuid) {
        //todo memberUuid -> memberSeq
        Long memberSeq = Long.parseLong(memberUuid);
        NamecardMain namecardMain = findByMemberSeq(memberSeq);
        log.info("메인페이지 조회: {}", namecardMain);
        return namecardMain;
    }
}
