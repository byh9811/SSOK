package com.ssok.namecard.domain.service;

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
        /** todo : memberUuid -> memberId로 변경 로직 작성해야함 */
        Long memberId = 1L;
        Namecard namecard = Namecard.from(namecardCreateRequest, memberId, uploadUrl);
        namecardRepository.save(namecard);
    }

    public void exchangeSingle(ExchangeSingleRequest exchangeSingleRequest) {

        /* 명함 교환 했었는지 여부 */
        Long memberBId = exchangeSingleRequest.memberBId();
        Long namecardAId = exchangeSingleRequest.namecardAId();

        exchangeRepository.findByNamecardIdAndMemberId(namecardAId, memberBId).ifPresentOrElse(
            value -> {
                /* A가 B명함 받음 */
                Exchange exchangeA = Exchange.builder()
                                             .exchangeLatitude(exchangeSingleRequest.lat())
                                             .exchangeLongitude(exchangeSingleRequest.lon())
                                             .exchangeNote("")
                                             .exchangeIsFavorite(false)
                                             .memberId(exchangeSingleRequest.memberAId())
                                             .namecardId(exchangeSingleRequest.namecardBId()).build();

                /* B가 A명함 받음 */
                Exchange exchangeB = Exchange.builder()
                                             .exchangeLatitude(exchangeSingleRequest.lat())
                                             .exchangeLongitude(exchangeSingleRequest.lon())
                                             .exchangeNote("")
                                             .exchangeIsFavorite(false)
                                             .memberId(exchangeSingleRequest.memberBId())
                                             .namecardId(exchangeSingleRequest.namecardAId()).build();
                exchangeRepository.save(exchangeA);
                exchangeRepository.save(exchangeB);
            },
            () -> {
                throw new ExchangeException(ErrorCode.EXCHANGE_DUPLICATED);
            }
        );
    }
}
