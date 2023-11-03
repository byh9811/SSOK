package com.ssok.base.domain.service;

import com.ssok.base.domain.api.dto.response.DomainJoinResponse;
import com.ssok.base.domain.api.dto.response.PocketResponse;
import com.ssok.base.domain.maria.entity.Pocket;
import com.ssok.base.domain.maria.entity.PocketHistory;
import com.ssok.base.domain.maria.repository.PocketRepository;
import com.ssok.base.domain.mongo.document.Domain;
import com.ssok.base.domain.mongo.repository.DomainMongoRepository;
import com.ssok.base.domain.service.dto.DomainDto;
import com.ssok.base.domain.service.dto.PocketHistoryDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.NoSuchElementException;
import java.util.Optional;

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


    public PocketResponse createPocket(String memberUuid) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = 1L;

        Optional<Pocket> findPocket = pocketRepository.findById(memberSeq);
        if(findPocket.isPresent()){
            throw new DuplicateKeyException("중복된 값 입니다."); // http 에러 코드 같이 보내는거로 수정
        }

        Pocket pocket = Pocket.builder()
                .memberSeq(memberSeq)
                .pocketSaving(0L)
                .pocketTotalDonate(0L)
                .pocketTotalPoint(0L)
                .build();

        pocketRepository.save(pocket);

        // Pocket 도메인 저장
        //domainMongoRepository.createPocket(pocket);

        return PocketResponse.of(pocket);

    }

    public void createPocketHistory(PocketHistoryDto dto) {
    }
}
