package com.ssok.namecard.domain.api;

import static com.ssok.namecard.global.api.ApiResponse.OK;

import com.ssok.namecard.client.MemberServiceClient;
import com.ssok.namecard.domain.api.dto.request.ExchangeSingleRequest;
import com.ssok.namecard.domain.api.dto.response.NamecardMainResponse;
import com.ssok.namecard.domain.mongo.document.NamecardMain;
import com.ssok.namecard.domain.service.NamecardQueryService;
import com.ssok.namecard.domain.service.NamecardService;
import com.ssok.namecard.domain.service.dto.NamecardCreateRequest;
import com.ssok.namecard.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/namecard-service")
public class NamecardController {

    private final NamecardService namecardService;
    private final NamecardQueryService namecardQueryService;
    private final MemberServiceClient memberServiceClient;

    /**
     * 명함 등록
     */
    @PostMapping("/")
    public ApiResponse<Void> createNamecardRequest(
        @RequestHeader(name = "MEMBER-UUID") String memberUuid,
        @RequestPart NamecardCreateRequest namecardCreateRequest,
        @RequestPart MultipartFile multipartFile
    ){
        log.info("UUID: {}", memberUuid);
        namecardService.createNamecard(namecardCreateRequest, memberUuid, multipartFile);
        return OK(null);
    }

    /**
     * 1:1 명함 교환
     */
    @PostMapping("/exchange/single")
    public ApiResponse<Void> exchangeNamecards(
        @RequestBody ExchangeSingleRequest exchangeSingleRequest
    ){
        namecardService.exchangeSingle(exchangeSingleRequest);
        return OK(null);
    }

    /** 명함 목록 조회 - 메인 */
    @GetMapping("/")
    public ApiResponse<NamecardMainResponse> getNamecardMain(
        @RequestHeader String memberUuid
    ){
        NamecardMain namecardMain = namecardQueryService.getNamecardMain(memberUuid);
        log.info("컨트롤러 메인페이지 로그: {}", namecardMain);
        NamecardMainResponse namecardMainResponse = new NamecardMainResponse(namecardMain);
        return OK(namecardMainResponse);
    }


    /** 명함 상세 조회 */
    @GetMapping("/{namecardId}")
    public ApiResponse<?> getNamecardDetail(@PathVariable Long namecardId){
        return OK(null);
    }

    /** 명함 지도 조회 */



    /** 명함 타임라인 조회 */

    /** 명함 메모 조회 */



    @GetMapping
    public ApiResponse<Long> getMemberSeq(@RequestHeader(name = "MEMBER-UUID") String memberUuid){
        return memberServiceClient.getMemberSeq(memberUuid);
    }



}
