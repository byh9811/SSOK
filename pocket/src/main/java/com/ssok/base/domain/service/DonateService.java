package com.ssok.base.domain.service;

import com.ssok.base.domain.maria.entity.Donate;
import com.ssok.base.domain.maria.entity.DonateMember;
import com.ssok.base.domain.maria.entity.Pocket;
import com.ssok.base.domain.maria.repository.DonateMemberRepository;
import com.ssok.base.domain.maria.repository.DonateRepository;
import com.ssok.base.domain.maria.repository.PocketRepository;
import com.ssok.base.domain.service.dto.DonateDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.NoSuchElementException;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class DonateService {
    private final DonateMemberRepository donateMemberRepository;
    private final DonateRepository donateRepository;
    private final PocketRepository pocketRepository;
    private final PocketService pocketService;

    public void createDonate(DonateDto dto) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(dto.getMemberUuid());

        // pocket 존재 여부
        Pocket findPocket = pocketRepository.findById(memberSeq).orElseThrow(() -> new NoSuchElementException("Pocket이 존재하지 않습니다"));

        // 금액이 양수인지 검사
        if(dto.getDonateAmt() <= 0){
            throw new IllegalArgumentException("이동 금액은 0원 이상이여야 합니다.");
        }

        // 포켓머니 금액 검사
        if(dto.getDonateAmt() > findPocket.getPocketSaving()){
            throw new IllegalArgumentException("보유 보켓머니가 부족합니다.");
        }

        Donate donate = donateRepository.findById(dto.getDonateSeq()).orElseThrow(() -> new NoSuchElementException("기부가 존재하지 않습니다"));

        // pocket history 생성
        pocketService.createDonationPocketHistory(dto.toDto(memberSeq, donate));
        // 기부 금액 적용
        findPocket.transferDonation(dto.getDonateAmt());

//        DonateMember = donateMemberRepository.findById()

//        Donate donate = Donate.builder()

    }





    /**
     * @author 홍진식
     *
     * Uuid로 member의 pk를 받거나, 유효한 멤버인지 확인하는 method
     *
     * @param memberUuid
     * @return memberSeq
     */
    private Long isMemberExist(String memberUuid){
        return 1L;
    }

}
