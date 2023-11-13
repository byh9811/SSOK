package com.ssok.base.domain.service;

import com.ssok.base.client.config.MemberServiceClient;
import com.ssok.base.domain.api.dto.request.DonateCreateRequest;
import com.ssok.base.domain.maria.entity.Donate;
import com.ssok.base.domain.maria.entity.DonateMember;
import com.ssok.base.domain.maria.entity.DonateMemberKey;
import com.ssok.base.domain.maria.entity.Pocket;
import com.ssok.base.domain.maria.repository.DonateMemberRepository;
import com.ssok.base.domain.maria.repository.DonateRepository;
import com.ssok.base.domain.maria.repository.PocketRepository;
import com.ssok.base.domain.mongo.document.DonateMain;
import com.ssok.base.domain.mongo.document.DonateMemberDoc;
import com.ssok.base.domain.mongo.repository.DonateMainMongoRepository;
import com.ssok.base.domain.mongo.repository.DonateMemberDocMongoRepository;
import com.ssok.base.domain.service.dto.DonateDto;
import com.ssok.base.global.exception.CustomException;
import com.ssok.base.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.NoSuchElementException;
import java.util.Optional;

/**
 * @author 홍진식
 */
@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class DonateService {
    private final DonateMemberRepository donateMemberRepository;
    private final DonateRepository donateRepository;
    private final PocketRepository pocketRepository;
    private final PocketService pocketService;
    private final DonateMainMongoRepository donateMainMongoRepository;
    private final DonateMemberDocMongoRepository donateMemberDocMongoRepository;
    private final MemberServiceClient memberServiceClient;
    /**
     * donate 생성 메서드
     *
     * @param request
     */
    public Long createDonate(DonateCreateRequest request) {
        Donate donate = Donate.builder()
                .donateTotalDonation(0L)
                .donateTotalDonator(0)
                .donateState(request.getDonateState())
                .donateTitle(request.getDonateTitle())
                .donateImage(request.getDonateImage())
                .build();
        donateRepository.save(donate);
        log.debug("donateSeq 다" + donate.getDonateSeq());
        DonateMain donateMain = DonateMain.fromDonate(donate);
        donateMainMongoRepository.save(donateMain);
        return donate.getDonateSeq();
    }
    /**
     * 기부진행 로직
     *
     * 예외처리
     * 1. 멤버 유효 검사 2.기부 유효 검사(존재, 종료) 3. DonateMember 없으면 생성  4. 금액 검사(pocketservice 위임) 5. DonateMember 존재 여부에 따른 비즈니스 로직 실행
     *
     * @param dto
     */
    public void doDonate(DonateDto dto) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(dto.getMemberUuid());
        Donate donate = donateRepository.findById(dto.getDonateSeq()).orElseThrow(() -> new NoSuchElementException("기부가 존재하지 않습니다"));
        if(!donate.getDonateState()){
            throw new IllegalArgumentException("종료된 기부입니다.");
        }
        Optional<DonateMember> findDonateMember = donateMemberRepository.findByDonateAndMemberSeq(donate, memberSeq);

        Boolean isDonateMemberExist = isDonateMemberExist(findDonateMember);

        DonateMember donateMember = null;
        if(isDonateMemberExist){
            donateMember = findDonateMember.get();
        }else{
            donateMember = DonateMember.builder()
                    .donate(donate)
                    .memberSeq(memberSeq)
                    .totalDonateAmt(0L)
                    .build();
        }
        log.debug(String.valueOf(donateMember.getMemberSeq()));

        // pocket history 생성 -> 금액 검사 모두 진행
        pocketService.createDonationPocketHistory(dto.toDto(memberSeq, donate));

        // 누적 기부금액 update
        donateMember.updateTotalDonateAmt(dto.getDonateAmt());

        // 기부 변경
        donate.updateDonation(dto.getDonateAmt(), isDonateMemberExist);

        // 만약 DonateMember가 존재하지 않았다면 저장
        if(!isDonateMemberExist){
            donateMemberRepository.save(donateMember);
        }
        // mongo

        DonateMemberDoc donateMemberDoc;
        if(!isDonateMemberExist){
            donateMemberDoc = DonateMemberDoc.builder()
                    .donateSeq(donate.getDonateSeq())
                    .memberSeq(memberSeq)
                    .totalDonateAmt(0L)
                    .build();
            log.warn("존재하지않습니다. 들어왔습니다.");
        }else{
            donateMemberDoc = donateMemberDocMongoRepository.findByDonateSeqAndMemberSeq(
                    donate.getDonateSeq(), memberSeq
            );
            log.warn("존재합니다.  ");
        }
        donateMemberDoc.updateAmt(dto.getDonateAmt());
        donateMemberDocMongoRepository.save(donateMemberDoc);
        // TODO: 2023-11-07 여기서에러남

        DonateMain donateMain = donateMainMongoRepository.findById(dto.getDonateSeq()).orElseThrow(() -> new IllegalArgumentException("등록되지 않은 기부입니다."));
        donateMain.updateDonateMain(donate);
        donateMainMongoRepository.save(donateMain);
    }

    /**
     * DonateMember가 있는지 찾는 함수
     *
     * @return true : 존재 / false : 미존재
     */
    private boolean isDonateMemberExist(Optional<DonateMember> findDonateMember){
        if(findDonateMember.isPresent()){
            return true;
        }
        return false;
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

}
