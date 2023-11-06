package com.ssok.base.domain.service;

import com.ssok.base.domain.api.dto.response.DomainJoinResponse;
import com.ssok.base.domain.api.dto.response.PocketResponse;
import com.ssok.base.domain.maria.entity.*;
import com.ssok.base.domain.maria.repository.*;
import com.ssok.base.domain.mongo.document.Domain;
import com.ssok.base.domain.mongo.document.PocketDetail;
import com.ssok.base.domain.mongo.document.PocketMain;
import com.ssok.base.domain.mongo.repository.DomainMongoRepository;
import com.ssok.base.domain.mongo.repository.PocketDetailMongoRepository;
import com.ssok.base.domain.mongo.repository.PocketMainMongoRepository;
import com.ssok.base.domain.service.dto.DomainDto;
import com.ssok.base.domain.service.dto.DonatePocketHistoryDto;
import com.ssok.base.domain.service.dto.PocketHistoryDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class PocketService {

    private final PocketRepository pocketRepository;
    private final DomainMongoRepository domainMongoRepository;
    private final PocketHistoryRepository pocketHistoryRepository;
    private final CarbonHistoryRepository carbonHistoryRepository;
    private final DonateHistoryRepository donateHistoryRepository;
    private final ChangeHistoryRepository changeHistoryRepository;
    private final PocketDetailMongoRepository pocketDetailMongoRepository;
    private final PocketMainMongoRepository pocketMainMongoRepository;
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

    /**
     * @author 홍진식
     *
     * pocket을 생성하는 메서드
     *
     * @param memberUuid : 멤버 식별값
     *
     */
    public PocketResponse createPocket(String memberUuid) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(memberUuid);

        Optional<Pocket> findPocket = pocketRepository.findById(memberSeq);
        if(findPocket.isPresent()){
            throw new DuplicateKeyException("중복된 값 입니다."); // http 에러 코드 같이 보내는거로 수정
        }

        Pocket pocket = Pocket.builder()
                .memberSeq(memberSeq)
                .pocketSaving(0L)
                .pocketTotalDonate(0L)
                .pocketTotalPoint(0L)
                .pocketTotalChange(0L)
                .build();

        pocketRepository.save(pocket);

        // 조회용 db 추가
        // Main에 추가
        PocketMain pocketMain = PocketMain.fromPocket(pocket);
        pocketMainMongoRepository.save(pocketMain);

        return PocketResponse.of(pocket);

    }

    /**
     * @author 홍진식
     *
     * 기부내역 생성 메서드
     *
     * @param dto
     */

    public void createDonationPocketHistory(DonatePocketHistoryDto dto){
        // 포켓 검색
        Pocket findPocket = pocketRepository.findById(dto.getMemberSeq()).orElseThrow(() -> new NoSuchElementException("Pocket이 존재하지 않습니다"));

        // 금액이 양수인지 검사
        if(dto.getPocketHistoryTransAmt() <= 0){
            throw new IllegalArgumentException("이동 금액은 0원 이상이여야 합니다.");
        }

        // 기부가 가능 한지 금액 검사
        checkIsTransfer(dto.getPocketHistoryTransAmt(), findPocket);
        // 기부(비즈니스 로직)
        findPocket.transferDonation(dto.getPocketHistoryTransAmt());

        // pocketHistory 생성
        PocketHistory pocketHistory = PocketHistory.builder()
                .memberSeq(dto.getMemberSeq())
                .pocketHistoryType(PocketHistoryType.DONATION)
                .pocketHistoryTransAmt(dto.getPocketHistoryTransAmt())
                .pocketHistoryResultAmt(findPocket.getPocketSaving())
                .pocketHistoryTitle("기부")
                .build();

        DonateHistory donateHistory = DonateHistory.builder()
                .pocketHistory(pocketHistory)
                .donate(dto.getDonate())
                .build();

        pocketHistoryRepository.save(pocketHistory);
        donateHistoryRepository.save(donateHistory);
        // Mongo - Update PocketMain
        PocketMain pocketMain = pocketMainMongoRepository.findById(findPocket.getMemberSeq()).orElseThrow(()
                -> new IllegalArgumentException("조회용이 존재하지 않는다."));
        pocketMain.updatePocketMain(findPocket);
        // Mongo - create PocketDetail
//        PocketDetail.fromPocketHistory()


    }


    /**
     * PocketHistory 생성 메소드
     *
     * @param dto
     */

    public void createPocketHistory(PocketHistoryDto dto) {
        // memberUuid로 pk 뽑기 / 없으면 에러처리
        Long memberSeq = isMemberExist(dto.getMemberUuid());

        // pocket 존재 여부
        Pocket findPocket = pocketRepository.findById(memberSeq).orElseThrow(() -> new NoSuchElementException("Pocket이 존재하지 않습니다"));

        // 금액이 양수인지 검사
        if(dto.getPocketHistoryTransAmt() <= 0){
            throw new IllegalArgumentException("이동 금액은 0원 이상이여야 합니다.");
        }

        // pocket 내역 변경
        Map<String, Object> resultMap = transferByHistoryType(dto, findPocket);

        PocketHistoryType type = (PocketHistoryType) resultMap.get("type");

        // pocketHistory 생성
        PocketHistory pocketHistory = PocketHistory.builder()
                .memberSeq(memberSeq)
                .pocketHistoryType(type)
                .pocketHistoryTransAmt(dto.getPocketHistoryTransAmt())
                .pocketHistoryResultAmt(findPocket.getPocketSaving())
                .pocketHistoryTitle(resultMap.get("title").toString())
                .build();
        // 내역 생성
        pocketHistoryRepository.save(pocketHistory);
        createTypeHistory(dto.getPocketHistoryType(), dto.getReceiptSeq(), pocketHistory);

        // Mongo
        PocketMain pocketMain = pocketMainMongoRepository.findById(findPocket.getMemberSeq()).orElseThrow(()
                -> new IllegalArgumentException("조회용이 존재하지 않는다."));

        // Mongo - update PocketDetail
        log.info(String.valueOf(findPocket.getPocketSaving()));
        pocketMain.updatePocketMain(findPocket);
        pocketMainMongoRepository.save(pocketMain);

        // Mongo - create PocketDetail
        PocketDetail pocketDetail = PocketDetail.fromPocketHistory(pocketHistory, dto.getReceiptSeq());
        pocketDetailMongoRepository.save(pocketDetail);

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


    private void createTypeHistory(String type, Long receiptSeq, PocketHistory pocketHistory){
        if(type.equals("CHANGE")){
            ChangeHistory changeHistory = ChangeHistory.builder()
                    .pocketHistory(pocketHistory)
                    .receiptSeq(receiptSeq)
                    .build();
            changeHistoryRepository.save(changeHistory);
        }
        if(type.equals("CARBON")){
            CarbonHistory carbonHistory = CarbonHistory.builder()
                    .pocketHistory(pocketHistory)
                    .receiptSeq(receiptSeq)
                    .build();
            carbonHistoryRepository.save(carbonHistory);
        }

    }


    /**
     * @author 홍진식
     *
     * Historytype에 따라 비즈니스 로직 실행하는 메소드
     *
     * @param dto
     * @param pocket
     * @return Map<String, Object> : (type, type Enum class) ,(title, 내역 제목)
     */
    private Map<String, Object> transferByHistoryType(PocketHistoryDto dto, Pocket pocket){
        Map<String, Object> resultMap = new HashMap<>();

        if(dto.getPocketHistoryType().equals("CHANGE")){
            pocket.transferChange(dto.getPocketHistoryTransAmt());
            resultMap.put("type",PocketHistoryType.CHANGE);
            resultMap.put("title", "잔돈 적립");
            return resultMap;
        }
        if(dto.getPocketHistoryType().equals("CARBON")){
            pocket.transferCarbon(dto.getPocketHistoryTransAmt());
            resultMap.put("type",PocketHistoryType.CARBON);
            resultMap.put("title", "탄소 중립포인트 적립");
            return resultMap;
        }
//        if(dto.getPocketHistoryType().equals("DONATION")){
//            checkIsTransfer(dto.getPocketHistoryTransAmt(), pocket);
//            pocket.transferDonation(dto.getPocketHistoryTransAmt());
//            resultMap.put("type",PocketHistoryType.DONATION);
//            resultMap.put("title", "기부");
//            return resultMap;
//        }
        if(dto.getPocketHistoryType().equals("WITHDRAWAL")){
            checkIsTransfer(dto.getPocketHistoryTransAmt(), pocket);
            pocket.transferWithdrawal(dto.getPocketHistoryTransAmt());
            // TODO: 2023-11-03 @홍진식 : 계좌 변경 요청 추가 필요
            resultMap.put("type",PocketHistoryType.WITHDRAWAL);
            resultMap.put("title", "출금");
            return resultMap;
        }

        throw new IllegalArgumentException("정확한 구분을 입력해주세요.");
    }

    /**
     * @author 홍진식
     * 출금, 기부 가능한지 확인 하는 메소드
     *
     * @param amt : 출금 금액
     * @param pocket
     */

    private void checkIsTransfer(Long amt, Pocket pocket){
        if(pocket.getPocketSaving() < amt){
            throw new IllegalArgumentException("금액이 부족합니다");
        }
    }






}
