package com.ssok.domainname.domain.service;

import com.ssok.domainname.domain.api.dto.response.DomainJoinResponse;
import com.ssok.domainname.domain.maria.repository.DomainRepository;
import com.ssok.domainname.domain.service.dto.DomainDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class DomainService {

    private final DomainRepository domainRepository;

    public DomainJoinResponse createDomain(DomainDto domainDto) {
        DomainJoinResponse domainJoinResponse = new DomainJoinResponse(domainDto.nickname(), domainDto.age());
        return domainJoinResponse;
    }

}
