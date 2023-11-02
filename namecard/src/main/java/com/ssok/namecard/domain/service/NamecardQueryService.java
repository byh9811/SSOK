package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.api.dto.response.DomainJoinResponse;
import com.ssok.namecard.domain.mongo.document.TestUser;
import com.ssok.namecard.domain.mongo.repository.NamecardMongoRepository;
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

    private final NamecardMongoRepository namecardMongoRepository;

    public DomainJoinResponse getDomain(NamecardDto namecardDto) {
        DomainJoinResponse domainJoinResponse = new DomainJoinResponse(namecardDto.nickname(), namecardDto.age());
        return domainJoinResponse;
    }

    public TestUser getUserByName(String name) {
        TestUser byName = namecardMongoRepository.findByName(name);
        log.info("{}", byName);
        return byName;
    }
}
