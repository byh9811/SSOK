package com.ssok.base.domain.service;

import com.ssok.base.client.config.MemberServiceClient;
import com.ssok.base.domain.api.dto.response.*;
import com.ssok.base.domain.maria.entity.PocketHistoryType;
import com.ssok.base.domain.mongo.document.PocketDetail;
import com.ssok.base.domain.mongo.document.PocketMain;
import com.ssok.base.domain.mongo.repository.DomainMongoRepository;
import com.ssok.base.domain.mongo.repository.PocketDetailMongoRepository;
import com.ssok.base.domain.mongo.repository.PocketMainMongoRepository;
import com.ssok.base.domain.service.dto.DomainDto;
import com.ssok.base.global.exception.CustomException;
import com.ssok.base.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class PocketQueryService {

    private final PocketMainMongoRepository pocketMainMongoRepository;
    private final PocketDetailMongoRepository pocketDetailMongoRepository;
    private final MemberServiceClient memberServiceClient;
    public DomainJoinResponse getDomain(DomainDto domainDto) {
        DomainJoinResponse domainJoinResponse = new DomainJoinResponse(domainDto.nickname(), domainDto.age());
        return domainJoinResponse;
    }

    /**
     * pocket 저축금액을 조회해주는 메서드
     * @param memberUuid
     * @return
     */

    public Long getPocketSaving(String memberUuid) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(memberUuid);

        PocketMain findPocketMain = pocketMainMongoRepository.findById(memberSeq).orElseThrow(() -> new IllegalArgumentException("Pocket이 존재하지 않습니다."));
        Long pocketSaving = findPocketMain.getPocketSaving();
        return pocketSaving;
    }

    public PocketResponse getPocket(String memberUuid) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(memberUuid);

        PocketMain findPocketMain = pocketMainMongoRepository.findById(memberSeq).orElseThrow(() -> new IllegalArgumentException("Pocket이 존재하지 않습니다."));
        return PocketResponse.fromPocketMain(findPocketMain);
    }

    /**
     * Uuid로 member의 pk를 받거나, 유효한 멤버인지 확인하는 method
     *
     * @param memberUuid
     * @return memberSeq
     */
    private Long isMemberExist(String memberUuid){
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        if(memberSeq == null){
            throw new CustomException(ErrorCode.MEMBER_NOT_FOUND);
        }
        return memberSeq;
    }

    public PocketDetailAllResponse getPocketDetail(String memberUuid, int detailType) {
        Map<YearMonth, List<PocketDetailResponse>> pocketDetailsMap = new HashMap<>();
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(memberUuid);
        // 포켓 금액
        Long pocketSaving = getPocketSaving(memberUuid);

        List<PocketDetail> pocketDetailList = new ArrayList<>();
        List<PocketHistoryType> types = new ArrayList<>();
        if(detailType == 0){ // 전체
            pocketDetailList = pocketDetailMongoRepository.findAllByMemberSeqOrderByCreateDateDesc(memberSeq);
        }
        else if(detailType == 1){ // 입금
            types.add(PocketHistoryType.CHANGE);
            types.add(PocketHistoryType.CARBON);
            pocketDetailList = pocketDetailMongoRepository.findAllByMemberSeqAndPocketHistoryTypeInOrderByCreateDateDesc(memberSeq, types);
        }
        else if(detailType == 2){ //
            types.add(PocketHistoryType.DONATION);
            types.add(PocketHistoryType.WITHDRAWAL);
            pocketDetailList = pocketDetailMongoRepository.findAllByMemberSeqAndPocketHistoryTypeInOrderByCreateDateDesc(memberSeq, types);
        }else{
            throw new IllegalArgumentException("정확한 상세조회 구분을 입력해주세요");
        }


        if(pocketDetailList.size() == 0){
            throw new IllegalArgumentException("상세 내역이 없습니다.");
        }


        // 월별로 나누기
        for(PocketDetail pocketDetail : pocketDetailList){
            YearMonth yearMonth = YearMonth.from(pocketDetail.getCreateDate());
            if (!pocketDetailsMap.containsKey(yearMonth)) {
                pocketDetailsMap.put(yearMonth, new ArrayList<>());
            }
            pocketDetailsMap.get(yearMonth).add(PocketDetailResponse.fromPocketDetail(pocketDetail));
        }

        Map<YearMonth, PocketDetailResponses> result = new HashMap<>();
        // 월 별 계산 로직
        for(Map.Entry<YearMonth, List<PocketDetailResponse>> entry : pocketDetailsMap.entrySet()){
            YearMonth key = entry.getKey();
            List<PocketDetailResponse> value = entry.getValue();
            Long deposit = 0L;
            Long withdrawal = 0L;
            for(PocketDetailResponse response : value){
                if(response.getPocketHistoryType().equals(PocketHistoryType.CARBON)){
                    deposit += response.getPocketHistoryTransAmt();
                }
                if(response.getPocketHistoryType().equals(PocketHistoryType.CHANGE)){
                    deposit += response.getPocketHistoryTransAmt();
                }
                if(response.getPocketHistoryType().equals(PocketHistoryType.DONATION)){
                    withdrawal += response.getPocketHistoryTransAmt();
                }
                if(response.getPocketHistoryType().equals(PocketHistoryType.WITHDRAWAL)){
                    withdrawal += response.getPocketHistoryTransAmt();
                }
            }
            result.put(key, PocketDetailResponses.builder()
                    .pocketDetailResponses(value)
                    .totalHistory(value.size())
                    .deposit(deposit)
                    .withdrawal(withdrawal)
                    .build());
        }
        return PocketDetailAllResponse.builder()
                .pocketDetailMap(result)
                .pocketSaving(pocketSaving)
                .build();
    }

    public Boolean getPocketIsChangeSaving(String memberUuid) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(memberUuid);
        PocketMain findPocketMain = pocketMainMongoRepository.findById(memberSeq).orElseThrow(() -> new IllegalArgumentException("Pocket이 존재하지 않습니다."));
        return findPocketMain.getPocketIsChangeSaving();
    }
}
