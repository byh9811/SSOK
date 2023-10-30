package com.ssok.domainname.domain.service;

import com.ssok.domainname.domain.api.dto.response.DomainJoinResponse;
import com.ssok.domainname.domain.mongo.repository.DomainMongoRepository;
import com.ssok.domainname.domain.service.dto.DomainDto;
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
