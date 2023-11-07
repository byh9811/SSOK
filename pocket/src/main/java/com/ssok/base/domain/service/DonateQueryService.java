package com.ssok.base.domain.service;

import com.ssok.base.domain.api.dto.response.DonatesResponse;
import com.ssok.base.domain.maria.repository.DonateMemberRepository;
import com.ssok.base.domain.mongo.document.DonateMain;
import com.ssok.base.domain.mongo.document.DonateMemberDoc;
import com.ssok.base.domain.mongo.repository.DonateMainMongoRepository;
import com.ssok.base.domain.mongo.repository.DonateMemberDocMongoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class DonateQueryService {
    private final DonateMainMongoRepository donateMainMongoRepository;
    private final DonateMemberRepository donateMemberRepository;
    private final DonateMemberDocMongoRepository donateMemberDocMongoRepository;


    public List<DonatesResponse> getDonates(String memberUuid) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(memberUuid);

        // 회원 id로 조회
        List<DonateMemberDoc> donateMemberDocs = donateMemberDocMongoRepository.findAllByMemberSeq(memberSeq);
        // Map형태로 변환
        Map<Long, Long> totalAmtMap = donateMemberDocs.stream().collect(
                Collectors.toMap(DonateMemberDoc::getDonateSeq, DonateMemberDoc::getTotalDonateAmt));
//        List<DonateMain> donateMains = donateMainMongoRepository.findAllByOrderByDonateStateDesc();
        List<DonateMain> donateMains = donateMainMongoRepository.findAll(Sort.by("donateState").descending().and(Sort.by("createDate").descending()));

        if(donateMains.size() == 0){
            throw new IllegalArgumentException("기부가 존재하지 않습니다.");
        }

        List<DonatesResponse> responses = new ArrayList<>();
        for(DonateMain donateMain : donateMains){
            Long memberTotalDonateAmt = 0L;
            if(totalAmtMap.containsKey(donateMain.getDonateSeq())){
                memberTotalDonateAmt = totalAmtMap.get(donateMain.getDonateSeq());
            }
            responses.add(DonatesResponse.fromDonateMain(donateMain, memberTotalDonateAmt));
        }
        return responses;
    }


    private Long isMemberExist(String memberUuid){
        return 1L;
    }
}
