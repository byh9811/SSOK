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
import java.util.Optional;
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

    public Namecard findById(Long id){
        return namecardRepository.findById(id)
                                 .orElseThrow(
                                     () -> new NamecardException(ErrorCode.NAMECARD_NOT_FOUND)
                                 );
    }

    public void createNamecard(NamecardCreateRequest namecardCreateRequest, String memberUuid, MultipartFile multipartFile) {

        if (multipartFile == null) {
            throw new NamecardException(ErrorCode.NAMECARD_BAD_REQUEST);
        }
        String uploadUrl = gcsService.uploadFile(multipartFile);

        Long memberSeq =  memberServiceClient.getMemberSeq(memberUuid).getResponse();
        Namecard namecard = Namecard.from(namecardCreateRequest, memberSeq, uploadUrl);
        Namecard savedNamecard = namecardRepository.save(namecard);

        namecardEventHandler.createNamecard(uploadUrl, memberSeq, savedNamecard.getNamecardSeq());
    }

    public void exchangeSingle(ExchangeSingleRequest exchangeSingleRequest) {

        /* 명함 교환 했었는지 여부 */
        Long memberBSeq = exchangeSingleRequest.memberBSeq();
        Namecard namecardA = findById(exchangeSingleRequest.namecardASeq());
        Namecard namecardB = findById(exchangeSingleRequest.namecardASeq());
        Optional<Exchange> byNamecardSeqAndMemberSeq = exchangeRepository.findByNamecard_NamecardSeqAndMemberSeq(
            namecardA.getNamecardSeq(), memberBSeq);
        if(byNamecardSeqAndMemberSeq != null){
            Exchange exchangeA = Exchange.builder()
                                         .exchangeLatitude(exchangeSingleRequest.lat())
                                         .exchangeLongitude(exchangeSingleRequest.lon())
                                         .exchangeNote("")
                                         .exchangeIsFavorite(false)
                                         .memberSeq(exchangeSingleRequest.memberASeq())
                                         .namecard(namecardB).build();
            /* B가 A명함 받음 */
            Exchange exchangeB = Exchange.builder()
                                         .exchangeLatitude(exchangeSingleRequest.lat())
                                         .exchangeLongitude(exchangeSingleRequest.lon())
                                         .exchangeNote("")
                                         .exchangeIsFavorite(false)
                                         .memberSeq(exchangeSingleRequest.memberBSeq())
                                         .namecard(namecardA).build();
            exchangeRepository.save(exchangeA);
            exchangeRepository.save(exchangeB);

            namecardEventHandler.exchangeNamecard(namecardA, namecardB, exchangeA, exchangeB);
        } else{
            throw new ExchangeException(ErrorCode.EXCHANGE_DUPLICATED);
        }

    }
}
