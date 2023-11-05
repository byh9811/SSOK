package com.ssok.namecard.domain.service;

import com.ssok.namecard.client.MemberServiceClient;
import com.ssok.namecard.domain.api.dto.request.ExchangeSingleRequest;
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

    public Long createNamecard(NamecardCreateRequest namecardCreateRequest, String memberUuid, MultipartFile multipartFile) {

        if (multipartFile == null) {
            throw new NamecardException(ErrorCode.NAMECARD_BAD_REQUEST);
        }
        String uploadUrl = gcsService.uploadFile(multipartFile);

        Long memberSeq =  memberServiceClient.getMemberSeq(memberUuid).getResponse();
        Namecard namecard = Namecard.from(namecardCreateRequest, memberSeq, uploadUrl);
        Namecard savedNamecard = namecardRepository.save(namecard);

        //몽고디비 용
        namecardEventHandler.createNamecard(savedNamecard);
        
        return savedNamecard.getNamecardSeq();
    }

    public void exchangeSingle(ExchangeSingleRequest exchangeSingleRequest) {

        /* A명함 조회 */
        Namecard namecardA = findBySeq(exchangeSingleRequest.namecardASeq());

        /* B명함 조회 */
        Namecard namecardB = findBySeq(exchangeSingleRequest.namecardBSeq());

        /* 명함을 교환했다면 x */
        List<Exchange> betweenTwoNamecards = exchangeRepository.findAllExchangesBetweenTwoNamecards(namecardA, namecardB);
        if(!betweenTwoNamecards.isEmpty()) throw new ExchangeException(ErrorCode.EXCHANGE_DUPLICATED);

        /* 명함을 교환하지 않았다면 교환 */
        List<Exchange> exchangeList = makeExchanges(namecardA, namecardB, exchangeSingleRequest.lat(), exchangeSingleRequest.lon());
        exchangeRepository.saveAll(exchangeList);
        namecardEventHandler.exchangeNamecard(namecardA, namecardB, exchangeList);
    }

    private List<Exchange> makeExchanges(Namecard namecardA, Namecard namecardB, Double lat,
        Double lon) {

        List<Exchange> exchangeList = new ArrayList<>();
        Exchange exchangeAtoB = makeExchange(lat, lon, namecardA, namecardB);
        Exchange exchangeBtoA = makeExchange(lat, lon, namecardB, namecardA);
        exchangeList.add(exchangeAtoB);
        exchangeList.add(exchangeBtoA);
        return exchangeList;
    }

    private Exchange makeExchange(Double lat, Double lon, Namecard namecardA, Namecard namecardB) {
        return Exchange.builder()
                       .exchangeLatitude(lat)
                       .exchangeLongitude(lon)
                       .sendNamecard(namecardA)
                       .receiveNamecard(namecardB)
                       .build();
    }

    public void createMemo(String memberUuid, Long namecardSeq) {
//        Long memberSeq =  memberServiceClient.getMemberSeq(memberUuid).getResponse();
//        Namecard myNamecard = namecardRepository.findAllByMemberSeqOrderByDesc(); //내가 가진 명함 중 가장 최신에 만든 것
//        exchangeRepository.findBySendNamecardIdAndReceiveNamecardId(myNamecard.getNamecardSeq())
//
//        List<Namecard> namecardList = namecardRepository.findAllByMemberSeq();
    }
}
