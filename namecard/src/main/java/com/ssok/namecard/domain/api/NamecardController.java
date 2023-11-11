package com.ssok.namecard.domain.api;

import static com.ssok.namecard.global.api.ApiResponse.OK;

import com.ssok.namecard.domain.api.dto.request.ExchangeSingleRequest;
import com.ssok.namecard.domain.api.dto.response.NamecardDetailDocResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardMainDocResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardMapResponse;
import com.ssok.namecard.domain.api.dto.response.NamecardSearchResponse;
import com.ssok.namecard.domain.service.NamecardQueryService;
import com.ssok.namecard.domain.service.NamecardService;
import com.ssok.namecard.domain.service.dto.NamecardCreateRequest;
import com.ssok.namecard.global.api.ApiResponse;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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

    /**
     * 명함 등록
     * @PostMapping(consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
     */
    @PostMapping(path = "/", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ApiResponse<Long> createNamecardRequest(
        @RequestHeader(name = "MEMBER-UUID") String memberUuid,
        @RequestPart NamecardCreateRequest namecardCreateRequest,
        @RequestPart(name = "image") MultipartFile multipartFile
    ){
        log.info("UUID: {}", memberUuid);
        Long namecardSeq = namecardService.createNamecard(namecardCreateRequest, memberUuid,
            multipartFile);
        return OK(namecardSeq);
    }

    /**
     * 1:1 명함 교환
     */
    @PostMapping("/exchange/single")
    public ApiResponse<String> exchangeNamecards(
        @RequestHeader(name = "MEMBER-UUID") String memberUuid,
        @RequestBody ExchangeSingleRequest exchangeSingleRequest
    ){
        namecardService.exchangeSingle(memberUuid, exchangeSingleRequest);
        return OK("명함 교환 완료");
    }

    /** 명함 메모 작성 (변경도 동일 api)*/
    @PostMapping("/memo/{exchangeSeq}")
    public ApiResponse<String> editMemo(
        @RequestHeader(name = "MEMBER-UUID") String memberUuid,
        @PathVariable Long exchangeSeq,
        @RequestBody String content
    ){
        namecardService.editMemo(memberUuid, exchangeSeq, content);
        return OK("메모 등록 완료");
    }



    /** 명함 목록 조회 - 메인 */
    @GetMapping("/")
    public ApiResponse<NamecardMainDocResponse> getNamecardMainDoc(
        @RequestHeader(name = "MEMBER-UUID") String memberUuid
    ){
        NamecardMainDocResponse namecardMainDocResponse = namecardQueryService.getNamecardMainDoc(memberUuid);
        log.info("메인페이지 body 로그: {}", namecardMainDocResponse);
        return OK(namecardMainDocResponse);
    }


    /**
     * 명함 상세 조회
     */
    @GetMapping("/{exchangeSeq}")
    public ApiResponse<NamecardDetailDocResponse> getNamecardDetailDoc(
        @PathVariable Long exchangeSeq,
        @RequestHeader(name = "MEMBER-UUID") String memberUuid)
    {
        NamecardDetailDocResponse namecardDetailDocResponse = namecardQueryService.getNamecardDetailDoc(exchangeSeq, memberUuid);
        log.info("명함 상세 body 로그: {}", namecardDetailDocResponse);
        return OK(namecardDetailDocResponse);
    }

    /** 명함지도 조회 */
    @GetMapping("/map")
    public ApiResponse<List<NamecardMapResponse>> getNamecardByMap(
        @RequestHeader(name = "MEMBER-UUID") String memberUuid
    ){
        List<NamecardMapResponse> namecardMapResponses = namecardService.getNamecardMapList(memberUuid);
        return OK(namecardMapResponses);
    }

    /** 즐겨 찾기 - 성공 후 교환 Seq을 반환함 */
    @PostMapping("/like")
    public ApiResponse<Long> likeNamecard(
        @RequestHeader(name = "MEMBER-UUID") String memberUuid,
        @RequestBody Long exchangeSeq
    ) {
        Long likedNamecardId = namecardService.likeNamecard(memberUuid, exchangeSeq);
        return  OK(likedNamecardId);
    }


    /** 명함 타임라인 조회 */
    @GetMapping("/timeline/{exchangeSeq}")
    public ApiResponse<List<String>> getNamecardTimeline(
        @PathVariable Long exchangeSeq
    ){
        List<String> timeline = namecardService.getNamecardTimeline(exchangeSeq);
        return OK(timeline);
    }

    /** 명함 메모 조회 */
    @GetMapping("/memo/{exchangeSeq}")
    public ApiResponse<String> getNamecardMemo(
        @PathVariable Long exchangeSeq
    ){
        String memo = namecardService.getNamecardMemo(exchangeSeq);
        return OK(memo);
    }


    /** 명함 이름 검색 */
    @GetMapping("/search")
    public ApiResponse<List<NamecardSearchResponse>> getNamecardSearch(
        @RequestHeader(name = "MEMBER-UUID") String memberUuid,
        @RequestParam String name
    ){
        List<NamecardSearchResponse> searchResponseList = namecardService.getNamecardSearch(memberUuid, name);
        return OK(searchResponseList);
    }

    /** 명함 있는지 여부 */
    @GetMapping("/exist")
    public ApiResponse<Boolean> isNamecardExist(
        @RequestHeader(name = "MEMBER-UUID") String memberUuid
    ){
        Boolean isNamecardExist = namecardService.isNamecardExist(memberUuid);
        return OK(isNamecardExist);
    }

    @PostMapping("/test")
    public ApiResponse<String> imageTest(
        @RequestPart(name = "image") MultipartFile file
    ){
        namecardService.uploadFileTest(file);
        return OK("이미지 업로드 성공입니다.");
    }
}
