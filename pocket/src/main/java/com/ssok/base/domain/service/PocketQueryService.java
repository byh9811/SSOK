package com.ssok.base.domain.service;

import com.ssok.base.domain.api.dto.response.DomainJoinResponse;
import com.ssok.base.domain.mongo.repository.DomainMongoRepository;
import com.ssok.base.domain.service.dto.DomainDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class DomainQueryService {

    private final DomainMongoRepository domainMongoRepository;

    public DomainJoinResponse getDomain(DomainDto domainDto) {
        DomainJoinResponse domainJoinResponse = new DomainJoinResponse(domainDto.nickname(), domainDto.age());
        return domainJoinResponse;
    }

}
