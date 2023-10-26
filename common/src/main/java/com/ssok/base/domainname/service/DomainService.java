package com.ssok.base.domainname.service;

import com.ssok.base.domainname.api.dto.response.DomainJoinResponse;
import com.ssok.base.domainname.service.dto.DomainDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class DomainService {

    public DomainJoinResponse joinDomain(DomainDto domainDto) {
        DomainJoinResponse domainJoinResponse = new DomainJoinResponse(domainDto.nickname(), domainDto.age());
        return domainJoinResponse;
    }

}
