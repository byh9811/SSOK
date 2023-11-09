package com.ssok.namecard.domain.service;

import com.ssok.namecard.client.MemberServiceClient;
import com.ssok.namecard.domain.api.dto.request.ExchangeSingleRequest;
import com.ssok.namecard.domain.api.dto.response.NamecardMapResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardSearchResponse;
import com.ssok.namecard.domain.exception.ExchangeException;
import com.ssok.namecard.domain.exception.NamecardException;
import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import com.ssok.namecard.domain.maria.repository.ExchangeRepository;
import com.ssok.namecard.domain.maria.repository.NamecardRepository;
import com.ssok.namecard.domain.service.dto.NamecardCreateRequest;
import com.ssok.namecard.global.exception.ErrorCode;
import com.ssok.namecard.global.service.GCSService;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
    private final NamecardEventHandler namecardEventHandler;
    private final MemberServiceClient memberServiceClient;

    public Namecard findBySeq(Long namecardSeq){
        return namecardRepository.findByNamecardSeq(namecardSeq)
                                 .orElseThrow(
                                     () -> new NamecardException(ErrorCode.NAMECARD_NOT_FOUND)
                                 );
    }
    public Namecard findByMemberSeq(Long memberSeq){
        return namecardRepository.findByMemberSeq(memberSeq)
                                 .orElseThrow(
                                     () -> new NamecardException(ErrorCode.NAMECARD_NOT_FOUND)
                                 );
    }

    public Exchange findBySendNamecardNamecardSeqAndReceiveNamecardNamecardSeq(Long sendNamecardId, Long receiveNamecardId) {
        return exchangeRepository.findBySendNamecardNamecardSeqAndReceiveNamecardNamecardSeq(sendNamecardId,
                              receiveNamecardId)
                          .orElseThrow(
                              () -> new ExchangeException(ErrorCode.EXCHANGE_NOT_FOUND)
                          );
    }

    public Long createNamecard(NamecardCreateRequest namecardCreateRequest, String memberUuid, MultipartFile multipartFile) {

        if (multipartFile == null) {
            throw new NamecardException(ErrorCode.NAMECARD_BAD_REQUEST);
        }
        String uploadUrl = gcsService.uploadFile(multipartFile);

        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        Namecard namecard = Namecard.from(namecardCreateRequest, memberSeq, uploadUrl);
        Namecard savedNamecard = namecardRepository.save(namecard);

        //몽고디비 용
        namecardEventHandler.createNamecard(savedNamecard);
        return savedNamecard.getNamecardSeq();
    }

    public void exchangeSingle(String memberUuid, ExchangeSingleRequest exchangeSingleRequest) {
        /* A명함 조회 */
        Namecard namecardA = findBySeq(exchangeSingleRequest.namecardASeq());

        /* B명함 조회 */
        Namecard namecardB = findBySeq(exchangeSingleRequest.namecardBSeq());

        /* 로그인 한 사람이 명함 요청의 주체인지 검증 */
        isValid(memberUuid, namecardA);

        /* 명함을 교환했다면 x */
        isDuplicated(namecardA, namecardB);

        /* 명함을 교환하지 않았다면 교환 */
        log.info("교환 시작: {}, {}", namecardA, namecardB);
        Exchange exchange = makeExchange(exchangeSingleRequest.lat(), exchangeSingleRequest.lon(), namecardA, namecardB);
        exchangeRepository.save(exchange);
        log.info("주체A (B의 명함받음) MariaDB에 저장 완료");
        namecardEventHandler.exchangeNamecard(namecardA, namecardB, exchange);
    }

    private void isDuplicated(Namecard namecardA, Namecard namecardB) {
        List<Exchange> betweenTwoNamecards = exchangeRepository.findAllExchangesBetweenTwoNamecards(
            namecardA, namecardB);
        if(!betweenTwoNamecards.isEmpty()) throw new ExchangeException(ErrorCode.EXCHANGE_DUPLICATED);
    }

    private void isValid(String memberUuid, Namecard namecardA) {
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        if(namecardA.getMemberSeq() != memberSeq){
            throw new ExchangeException(ErrorCode.EXCHANGE_BAD_REQUEST);
        }
    }

    private Exchange makeExchange(Double lat, Double lon, Namecard namecardA, Namecard namecardB) {
        return Exchange.builder()
                       .exchangeLatitude(lat)
                       .exchangeLongitude(lon)
                       .exchangeNote("")
                       .exchangeIsFavorite(false)
                       .sendNamecard(namecardA)
                       .receiveNamecard(namecardB)
                       .build();
    }

    public void editMemo(String memberUuid, Long exchangeSeq, String content) {

        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();

        //교환명함 찾기
        Exchange exchange = exchangeRepository.findByExchangeSeq(exchangeSeq)
                                              .orElseThrow(
                                                  () -> new ExchangeException(ErrorCode.EXCHANGE_NOT_FOUND)
                                              );
        exchange.editMemo(content);
        namecardEventHandler.editMemo(memberSeq, exchange, content);
    }

    public List<NamecardMapResponse> getNamecardMapList(String memberUuid) {
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        List<Namecard> namecardList = namecardRepository.findAllByMemberSeq(memberSeq);
        List<Exchange> exchangeList = namecardList.stream() // Stream<Namecard> 생성
                                                  .flatMap(namecard -> namecard.getExchanges().stream()) // Stream<List<Exchange>>를 Stream<Exchange>로 평탄화
                                                  .collect(Collectors.toList()); // 평탄화된 Stream<Exchange>를 List<Exchange>로 수집
        return exchangeList.stream()
                           .map(
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
        exchange.updateFavorite();

        //mongo todo - 즐겨 찾기 표시 및 조회 시 favorite 리스트에 넣어주기
        namecardEventHandler.updateFavorite(exchange);
        return exchangeSeq;
    }

    public List<String> getNamecardTimeline(Long exchangeSeq) {
        Exchange exchange = exchangeRepository.findByExchangeSeq(exchangeSeq)
                                              .orElseThrow(
                                                  () -> new ExchangeException(ErrorCode.EXCHANGE_NOT_FOUND));
        Long memberSeq = exchange.getReceiveNamecard().getMemberSeq();
        log.info("회원 식별키: {}", memberSeq);
        List<String> findNamecardImageList = namecardRepository.findAllByMemberSeq(memberSeq)
            .stream()
            .map(namecard -> namecard.getNamecardImage()).collect(Collectors.toList());
        return findNamecardImageList;
    }

    public String getNamecardMemo(Long exchangeSeq) {
        Exchange exchange = exchangeRepository.findByExchangeSeq(exchangeSeq)
                                              .orElseThrow(
                                                  () -> new ExchangeException(ErrorCode.EXCHANGE_NOT_FOUND));
        return exchange.getExchangeNote();
    }

    public List<NamecardSearchResponse> getNamecardSearch(String memberUuid, String name) {
        Long memberSeq = memberServiceClient.getMemberSeq(memberUuid).getResponse();
        List<Namecard> namecardList = namecardRepository.findAllByMemberSeq(memberSeq);
        List<Exchange> exchangeList = namecardList.stream() // Stream<Namecard> 생성
                                                  .flatMap(namecard -> namecard.getExchanges().stream()) // Stream<List<Exchange>>를 Stream<Exchange>로 평탄화
                                                  .collect(Collectors.toList()); // 평탄화된 Stream<Exchange>를 List<Exchange>로 수집
        List<NamecardSearchResponse> searchResponseList = NamecardSearchResponse.from(exchangeList).stream()
                                                                                .filter(response -> response.name().contains(name))
                                                                                .collect(Collectors.toList());;
        return searchResponseList;
    }
}
