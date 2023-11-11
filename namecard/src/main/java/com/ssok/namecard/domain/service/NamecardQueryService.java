package com.ssok.namecard.domain.service;

import com.ssok.namecard.client.MemberServiceClient;
import com.ssok.namecard.domain.api.dto.response.NamecardDetailDocResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardMainDocResponse;
import com.ssok.namecard.domain.exception.NamecardDocException;
import com.ssok.namecard.domain.mongo.document.NamecardDetailDoc;
import com.ssok.namecard.domain.mongo.document.NamecardMainDoc;
import com.ssok.namecard.domain.mongo.repository.NamecardDetailDocMongoRepository;
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
    private final NamecardDetailDocMongoRepository namecardDetailDocMongoRepository;
    private final MemberServiceClient memberServiceClient;

    public NamecardMainDoc findByMemberSeq(Long memberSeq){
        return namecardMainDocMongoRepository.findByMemberSeq(memberSeq)
                                   .orElseThrow(
                                       () -> new NamecardDocException(ErrorCode.MONGO_NAMECARD_NOT_FOUND)
                                   );
    }

    public NamecardDetailDoc findByExchangeSeq(Long exchangeSeq){
        return namecardDetailDocMongoRepository.findByExchangeSeq(exchangeSeq)
                                               .orElseThrow(() -> new NamecardDocException(
                                                   ErrorCode.MONGO_NAMECARD_NOT_FOUND));

    }

    public NamecardMainDocResponse getNamecardMainDoc(String memberUuid) {

        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        log.info("memberSeq: {}", memberSeq);
        NamecardMainDoc namecardMainDoc = findByMemberSeq(memberSeq);
        log.info("메인페이지 조회: {}", namecardMainDoc);
        return new NamecardMainDocResponse(namecardMainDoc);
    }

    public NamecardDetailDocResponse getNamecardDetailDoc(Long exchangeSeq, String memberUuid) {
        NamecardDetailDoc namecardDetailDoc = findByExchangeSeq(exchangeSeq);

        return NamecardDetailDocResponse.from(namecardDetailDoc);
    }
}
