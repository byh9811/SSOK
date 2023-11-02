package com.ssok.base.domain.service;

import com.ssok.base.domain.api.dto.response.DomainJoinResponse;
import com.ssok.base.domain.maria.repository.PocketRepository;
import com.ssok.base.domain.mongo.document.Domain;
import com.ssok.base.domain.mongo.repository.DomainMongoRepository;
import com.ssok.base.domain.service.dto.DomainDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class PocketService {

    private final PocketRepository pocketRepository;
    private final DomainMongoRepository domainMongoRepository;

    public DomainJoinResponse createDomain(DomainDto domainDto) {
//        return pocketRepository.fin
        DomainJoinResponse domainJoinResponse = new DomainJoinResponse(domainDto.nickname(), domainDto.age());
        return domainJoinResponse;
    }
    /**
     *
     */
    public Domain getDomainById(int age){
        return domainMongoRepository.findByAge(age);

    }


}
