package com.ssok.namecard.domain.service;

import com.ssok.namecard.client.MemberServiceClient;
import com.ssok.namecard.domain.api.dto.request.ExchangeSingleRequest;
import com.ssok.namecard.domain.api.dto.response.MyExchangeItemResponse;
import com.ssok.namecard.domain.api.dto.response.MyNamecardDetailResponse;
import com.ssok.namecard.domain.api.dto.response.MyNamecardItemResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardDetailDocResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardMainDocResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardMapResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardSearchResponse;
import com.ssok.namecard.domain.api.dto.response.TimeLineResponse;
import com.ssok.namecard.domain.exception.ExchangeException;
import com.ssok.namecard.domain.exception.NamecardException;
import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import com.ssok.namecard.domain.maria.entity.UpdateStatus;
import com.ssok.namecard.domain.maria.repository.ExchangeRepository;
import com.ssok.namecard.domain.maria.repository.NamecardRepository;
import com.ssok.namecard.domain.service.dto.NamecardCreateRequest;
import com.ssok.namecard.global.exception.ErrorCode;
import com.ssok.namecard.global.service.GCSService;
import java.sql.Time;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.logging.log4j.util.Strings;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class NamecardService {

    private final NamecardRepository namecardRepository;
    private final ExchangeRepository exchangeRepository;
    private final GCSService gcsService;
    private final MemberServiceClient memberServiceClient;

    public Namecard findBySeqFromNamecardRepository(Long namecardSeq){
        return namecardRepository.findByNamecardSeq(namecardSeq)
                                 .orElseThrow(() -> new NamecardException(ErrorCode.NAMECARD_NOT_FOUND));
    }

    public Exchange findBySeqFromExchangeRepository(Long exchangeSeq){
        return exchangeRepository.findByExchangeSeq(exchangeSeq)
                                 .orElseThrow(() -> new ExchangeException(ErrorCode.EXCHANGE_NOT_FOUND));
    }

    public List<Namecard> findByMemberSeqFromNamecardRepository(Long memberSeq){
        return namecardRepository.findAllByMemberSeq(memberSeq);
    }


    public Long createNamecard(NamecardCreateRequest namecardCreateRequest, String memberUuid, MultipartFile multipartFile) {

        if (multipartFile == null) {
            throw new NamecardException(ErrorCode.NAMECARD_BAD_REQUEST);
        }
        String uploadUrl = gcsService.uploadFile(multipartFile);

        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        Namecard namecard = Namecard.from(namecardCreateRequest, memberSeq, uploadUrl);
        Namecard savedNamecard = namecardRepository.save(namecard);
        //본인을 루트 명함으로 설정
        Long parentSeq = savedNamecard.getNamecardSeq();
        savedNamecard.updateParentSeq(parentSeq);
        return savedNamecard.getNamecardSeq();
    }

    /* 내 명함 기존꺼 갱신하기 */
    public Long updateNamecard(NamecardCreateRequest namecardUpdateRequest, String memberUuid,
        MultipartFile file, Long preNamecardSeq) {

        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        String url = gcsService.uploadFile(file);
        Namecard preNamecard = findBySeqFromNamecardRepository(preNamecardSeq);
        Namecard preRootNamecard = findBySeqFromNamecardRepository(preNamecard.getRootNamecardSeq());

        //이전 명함이 있는 사람에게 업데이트 상태 갱신 - 루트로 찾아야 함.
        //교환 테이블에서 받은 명함으로 찾는데 받은 명함의 root가 preNamecard의 root와 같은 명함들을
        // 상태 update로 변경
        List<Exchange> findExchanges = exchangeRepository.findAllByReceiveNamecard_RootNamecardSeq(preRootNamecard.getNamecardSeq());
        findExchanges.forEach(Exchange::toUpdated);

        //대표 명함에서 해제
        preNamecard.updateOld();

        //새로운 명함을 루트를 똑같이 생성하고
        Namecard newNamecard = Namecard.from(namecardUpdateRequest, memberSeq, url, preNamecard.getRootNamecardSeq());
        // 대표 명함으로 설정
        newNamecard.updateNew();
        Namecard savedNamecard = namecardRepository.save(newNamecard);
        return savedNamecard.getNamecardSeq();
    }


    public void exchangeSingle(ExchangeSingleRequest exchangeSingleRequest) {
        /* A명함 조회 */
        Namecard namecardA = findBySeqFromNamecardRepository(exchangeSingleRequest.namecardASeq());

        /* B명함 조회 */
        Namecard namecardB = findBySeqFromNamecardRepository(exchangeSingleRequest.namecardBSeq());

        /* 이미 교환했던 명함 */
        checkDuplicate(namecardA, namecardB);

        /* 명함을 교환하지 않았다면 교환 */
        log.info("교환 시작: {}, {}", namecardA, namecardB);
        Exchange exchange = makeExchange(exchangeSingleRequest.lat(), exchangeSingleRequest.lon(), namecardA, namecardB);
        exchange.updateFirstDate(namecardB.getCreateDate().toLocalDate());
        exchangeRepository.save(exchange);
    }

    private void checkDuplicate(Namecard namecardA, Namecard namecardB) {
        //A의 교환 명함 목록을 찾는다.
        List<Exchange> allExchangesByMemberSeq = findAllExchangesByMemberSeq(namecardA.getMemberSeq());
        log.info("namecardB의 rootSeq: {}", namecardB.getRootNamecardSeq());
        //A의 교환 명함 목록을 순회하면서 그 명함과 교환한 명함의 부모가 같은지를 파악한다.
        boolean isDuplicated = allExchangesByMemberSeq.stream()
                                                      .anyMatch(
                                                          exchange -> {
                                                              log.info("A가 수행한 교환을 순회한다.");
                                                              log.info("받은 명함의 rootSeq: {}", exchange.getReceiveNamecard().getRootNamecardSeq());
                                                              return exchange.getReceiveNamecard()
                                                                      .getRootNamecardSeq()
                                                                      .equals(
                                                                          namecardB.getRootNamecardSeq());
                                                          });
        //있으면 exception
        if(isDuplicated) throw new ExchangeException(ErrorCode.EXCHANGE_DUPLICATED);
    }

    private Exchange makeExchange(Double lat, Double lon, Namecard namecardA, Namecard namecardB) {
        return Exchange.builder()
                       .sendNamecard(namecardA)
                       .receiveNamecard(namecardB)
                       .exchangeLatitude(lat)
                       .exchangeLongitude(lon)
                       .exchangeNote(Strings.EMPTY)
                       .exchangeIsFavorite(Boolean.FALSE)
                       .updateStatus(UpdateStatus.NEWLY)
                       .build();
    }

    public void editMemo(String memberUuid, Long exchangeSeq, String content) {
        if(content == null) content = "";

        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();

        //교환명함 찾기
        Exchange exchange = findBySeqFromExchangeRepository(exchangeSeq);
        //요청의 주체 검증
        checkAuth(memberSeq, exchange);
        exchange.editMemo(content);
    }

    private static void checkAuth(Long memberSeq, Exchange exchange) {
        if (!exchange.getSendNamecard().getMemberSeq().equals(memberSeq)) throw new ExchangeException(ErrorCode.UNAUTHORIZED);
    }

    public List<NamecardMapResponse> getNamecardMapList(String memberUuid) {
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        List<Exchange> exchangeList = findAllExchangesByMemberSeq(memberSeq);
        return exchangeList.stream().map(
                               e -> new NamecardMapResponse(e)
                           )
                           .collect(Collectors.toList());
    }

    public Long likeNamecard(String memberUuid, Long exchangeSeq) {
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();

        //mariadb
        Exchange exchange = exchangeRepository.findByExchangeSeq(exchangeSeq)
                                              .orElseThrow(
                                                  () -> new ExchangeException(
                                                      ErrorCode.EXCHANGE_NOT_FOUND)
                                              );
        if (!exchange.getSendNamecard()
                     .getMemberSeq()
                     .equals(memberSeq)) {
            throw new ExchangeException(ErrorCode.UNAUTHORIZED);
        }
        exchange.updateFavorite();
        return exchangeSeq;
    }

    public List<TimeLineResponse> getNamecardTimeline(Long exchangeSeq) {

        Exchange exchange = findBySeqFromExchangeRepository(exchangeSeq);
        //교환의 받은 명함을 찾음
        Namecard receivedNamecard = exchange.getReceiveNamecard();
        //그 명함의 회원의 명함들(root가 같아야함) 중 교환 날짜 이후의 명함들을 찾아서 넣기.
        Long memberSeq = receivedNamecard.getMemberSeq();
        List<Namecard> allByMemberSeqNamecards = findByMemberSeqFromNamecardRepository(memberSeq);
        List<TimeLineResponse> timelines = allByMemberSeqNamecards.stream()
                                                                  .filter(namecard -> namecard.getRootNamecardSeq().equals(receivedNamecard.getRootNamecardSeq()))
                                                                  .filter(namecard ->namecard.getCreateDate().toLocalDate().compareTo(exchange.getFirstNamecardCreateDate())>= 0)
                                                                  .map(namecard -> new TimeLineResponse(namecard))
                                                                  .collect(Collectors.toList());
        return timelines;
    }

    public String getNamecardMemo(Long exchangeSeq) {
        Exchange exchange = exchangeRepository.findByExchangeSeq(exchangeSeq)
                                              .orElseThrow(
                                                  () -> new ExchangeException(ErrorCode.EXCHANGE_NOT_FOUND));
        return exchange.getExchangeNote();
    }

    public List<NamecardSearchResponse> getNamecardSearch(String memberUuid, String name) {
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        List<Exchange> exchangeList = findAllExchangesByMemberSeq(memberSeq);
        List<NamecardSearchResponse> searchResponseList = NamecardSearchResponse.from(exchangeList).stream()
                                                                                .filter(response -> response.name().contains(name))
                                                                                .collect(Collectors.toList());;
        return searchResponseList;
    }

    public Boolean isNamecardExist(String memberUuid) {
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        List<Namecard> namecardList = findByMemberSeqFromNamecardRepository(memberSeq);
        if(namecardList.isEmpty()) return false;
        return true;
    }

    public void uploadFileTest(MultipartFile file) {
        String s = gcsService.uploadFile(file);
        log.info("================이미지 업로드 테스트==================");
        log.info(s);
        System.out.println(s);
    }


    public NamecardMainDocResponse getNamecardMain(String memberUuid) {
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();

        //내 명함들 중 대표 명함만 뽑음
        List<Namecard> myRepNamecards = findByMemberSeqFromNamecardRepository(memberSeq).stream().filter(
            namecard -> namecard.getIsRepNamecard().equals(Boolean.TRUE)
        ).collect(Collectors.toList());

        //내가 등록한 명함들에 해당하는 모든 교환들
        List<Exchange> exchanges = findAllExchangesByMemberSeq(memberSeq);

        List<MyNamecardItemResponse> myNamecardItemResponses = myRepNamecards.stream()
                                                                             .map(
                                                                                 namecard -> new MyNamecardItemResponse(
                                                                                     namecard))
                                                                             .collect(
                                                                                 Collectors.toList());
        List<MyExchangeItemResponse> myExchangeItemResponses = exchanges.stream()
                                                                        .map(
                                                                            exchange -> new MyExchangeItemResponse(
                                                                                exchange))
                                                                        .collect(
                                                                            Collectors.toList());
        List<MyExchangeItemResponse> favorites = exchanges.stream().filter(exchange -> exchange.getExchangeIsFavorite().equals(Boolean.TRUE))
                                                                        .map(
                                                                            exchange -> new MyExchangeItemResponse(
                                                                                exchange))
                                                                        .collect(
                                                                            Collectors.toList());

        NamecardMainDocResponse namecardMainDocResponse = new NamecardMainDocResponse(memberSeq, myNamecardItemResponses, myExchangeItemResponses, favorites);
        return namecardMainDocResponse;
    }

    private List<Exchange> findAllExchangesByMemberSeq(Long memberSeq) {
        //member
        List<Namecard> namecardList = findByMemberSeqFromNamecardRepository(memberSeq);
        return namecardList.stream() // Stream<Namecard> 생성
                           .flatMap(namecard -> namecard.getExchanges().stream()) // Stream<List<Exchange>>를 Stream<Exchange>로 평탄화
                           .collect(Collectors.toList());
    }

    public NamecardDetailDocResponse getNamecardDetailDoc(Long exchangeSeq) {
        Exchange exchange = findBySeqFromExchangeRepository(exchangeSeq);
        //교환의 받은 명함 찾기
        Namecard receiveNamecard = exchange.getReceiveNamecard();

        //updateStatus = checked
        exchange.toChecked();
        NamecardDetailDocResponse  namecardDetailDocResponse = new NamecardDetailDocResponse(exchange, receiveNamecard);
        return namecardDetailDocResponse;
    }

    public NamecardResponse updateOtherNamecard(Long exchangeSeq) {
        Exchange exchange = findBySeqFromExchangeRepository(exchangeSeq);
        //업데이트 시켜야할 명함
        Namecard toBeUpdatedNamecard = exchange.getReceiveNamecard();

        //그 명함의 히스토리 중 최신 명함
        //그 사람 찾기
        Long memberSeq = toBeUpdatedNamecard.getMemberSeq();
        //업데이트로 반영할 명함(최신명함)
        Namecard latestNamecard = findByMemberSeqFromNamecardRepository(memberSeq)
            .stream()
            .filter(
                namecard -> namecard.getIsRepNamecard()
                                    .equals(Boolean.TRUE)
            )
            .filter(
                namecard -> namecard.getRootNamecardSeq()
                                    .equals(toBeUpdatedNamecard.getRootNamecardSeq())
            )
            .findFirst()
            .orElseThrow(
                () -> new NamecardException(ErrorCode.NAMECARD_NOT_FOUND)
            );
        //그사람의 명함중 가장 최신인거 필터링
        //그 명함 중 root가 업데이트 시켜야할 root와 같은 것
        exchange.updateNamecard(latestNamecard);
        return new NamecardResponse(latestNamecard, exchange);
    }

    public MyNamecardDetailResponse getMyNamecardDetail(Long namecardSeq, String memberUuid) {
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        //내 명함 조회
        Namecard myNamecard = findBySeqFromNamecardRepository(namecardSeq);
        if(!myNamecard.getMemberSeq().equals(memberSeq)) throw new NamecardException(ErrorCode.NAMECARD_UNAUTHORIZED);
        MyNamecardDetailResponse  myNamecardDetailResponse = new MyNamecardDetailResponse(myNamecard);
        return myNamecardDetailResponse;
    }

    public List<TimeLineResponse> getMyTimeline(Long namecardSeq) {
        Namecard myNamecard = findBySeqFromNamecardRepository(namecardSeq);
        Long memberSeq = myNamecard.getMemberSeq();
        List<TimeLineResponse> myTimelines = findByMemberSeqFromNamecardRepository(memberSeq)
            .stream()
            .filter(namecard -> namecard.getRootNamecardSeq()
                                        .equals(myNamecard.getRootNamecardSeq()))
            .map(namecard -> new TimeLineResponse(namecard))
            .collect(Collectors.toList());
        return myTimelines;
    }
}
