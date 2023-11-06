package com.ssok.base.domain.service;

import com.ssok.base.domain.api.dto.response.DomainJoinResponse;
import com.ssok.base.domain.mongo.document.PocketMain;
import com.ssok.base.domain.mongo.repository.DomainMongoRepository;
import com.ssok.base.domain.mongo.repository.PocketMainMongoRepository;
import com.ssok.base.domain.service.dto.DomainDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class PocketQueryService {

    private final PocketMainMongoRepository pocketMainMongoRepository;
    public DomainJoinResponse getDomain(DomainDto domainDto) {
        DomainJoinResponse domainJoinResponse = new DomainJoinResponse(domainDto.nickname(), domainDto.age());
        return domainJoinResponse;
    }


    public Long getPocketSaving(String memberUuid) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(memberUuid);

        PocketMain findPocketMain = pocketMainMongoRepository.findById(memberSeq).orElseThrow(() -> new IllegalArgumentException("Pocket이 존재하지 않습니다."));
        Long pocketSaving = findPocketMain.getPocketSaving();
        return pocketSaving;
    }

    /**
     * Uuid로 member의 pk를 받거나, 유효한 멤버인지 확인하는 method
     *
     * @param memberUuid
     * @return memberSeq
     */
    private Long isMemberExist(String memberUuid){
        return 1L;
    }
}
