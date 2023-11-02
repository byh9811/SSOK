package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.api.dto.request.ExchangeSingleRequest;
import com.ssok.namecard.domain.exception.NamecardException;
import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import com.ssok.namecard.domain.maria.repository.ExchangeRepository;
import com.ssok.namecard.domain.maria.repository.NamecardRepository;
import com.ssok.namecard.domain.service.dto.NamecardCreateRequest;
import com.ssok.namecard.global.api.ApiError;
import com.ssok.namecard.global.api.ApiResponse;
import com.ssok.namecard.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class NamecardService {

    private final NamecardRepository namecardRepository;
    private final ExchangeRepository exchangeRepository;

    public Namecard findById(Long id){
        return namecardRepository.findById(id)
                                 .orElseThrow(
                                     () -> new NamecardException(ErrorCode.NAMECARD_NOT_FOUND)
                                 );
    }


    public void createNamecard(NamecardCreateRequest namecardCreateRequest, Long memberId) {
        Namecard namecard = Namecard.fromRequest(namecardCreateRequest, memberId);
        namecardRepository.save(namecard);
    }

    public void exchangeSingle(ExchangeSingleRequest exchangeSingleRequest) {

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
    }
}
