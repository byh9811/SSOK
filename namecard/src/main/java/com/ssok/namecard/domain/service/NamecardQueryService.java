package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.api.dto.response.DomainJoinResponse;
import com.ssok.namecard.domain.mongo.repository.NamecardMainMongoRepository;
import com.ssok.namecard.domain.service.dto.NamecardDto;
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

    public DomainJoinResponse getDomain(NamecardDto namecardDto) {
        DomainJoinResponse domainJoinResponse = new DomainJoinResponse(namecardDto.nickname(), namecardDto.age());
        return domainJoinResponse;
    }

}
