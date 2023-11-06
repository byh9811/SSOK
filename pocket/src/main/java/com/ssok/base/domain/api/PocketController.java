package com.ssok.base.domain.api;

import com.ssok.base.domain.api.dto.request.DomainJoinRequest;
import com.ssok.base.domain.api.dto.request.PocketHistoryRequest;
import com.ssok.base.domain.api.dto.response.DomainJoinResponse;
import com.ssok.base.domain.api.dto.response.PocketDetailAllResponse;
import com.ssok.base.domain.api.dto.response.PocketDetailResponses;
import com.ssok.base.domain.api.dto.response.PocketResponse;
import com.ssok.base.domain.maria.entity.Pocket;
import com.ssok.base.domain.maria.entity.PocketHistory;
import com.ssok.base.domain.service.PocketQueryService;
import com.ssok.base.domain.service.PocketService;
import com.ssok.base.global.api.ApiResponse;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.YearMonth;
import java.util.Map;

import static com.ssok.base.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/pocket-service")
public class PocketController {

    private final PocketService pocketService;
    private final PocketQueryService pocketQueryService;

    @PostMapping
    public ApiResponse<DomainJoinResponse> createDomain(
            @RequestBody DomainJoinRequest domainJoinRequest
//            @RequestHeader("Auth") String token
    ) {
        return OK(new DomainJoinResponse("dummy", 20));
    }

    @GetMapping
    public ApiResponse<DomainJoinResponse> getDomain(
            @RequestBody DomainJoinRequest domainJoinRequest
    ) {
        return OK(new DomainJoinResponse("dummy", 20));
    }

    @GetMapping("/test")
    public ApiResponse<?> test(){
        log.info("test in  in  in");
        return OK("TESTdONE");
    }

    @GetMapping("/mongo")
    public ApiResponse<?> mongoTest(){
        log.info("init");
        return OK(pocketService.getDomainById(18));
    }

    /**
     * @autor 홍진식
     *
     * @param memberUuid 헤더로부터 얻은 Uuid
     * @return PocketResponse
     */
    @PostMapping("/pocket")
    public ApiResponse<PocketResponse> createPocket(@RequestHeader String memberUuid){
        // 연동 계좌번호 확인 필요
        // 이미 등록되어 있는지 확인 필요

        // 헤더에서 Uuid 뽑기
        memberUuid = null;
        PocketResponse response = pocketService.createPocket(memberUuid);
        return OK(response);
    }

    /**
     * @autor 홍진식
     * @param request 요청 정보
     * @param memberUuid 헤더로부터 얻은 Uuid
     * @return
     */
    @PostMapping("/pocket/history")
    public ApiResponse<?> createPocketHistory(@RequestBody PocketHistoryRequest request, @RequestHeader String memberUuid){
        pocketService.createPocketHistory(request.toDto(memberUuid));
        return OK(null);
    }

    /**
     * 포켓 머니 저축 금액 조회
     * @param memberUuid
     * @return PocketSaving : 보유 저축 금액
     */
    @GetMapping("/pocket/saving")
    public ApiResponse<Long> getPocketSaving(@RequestBody @RequestHeader String memberUuid){
        Long pocketSaving = pocketQueryService.getPocketSaving(memberUuid);
        return ApiResponse.OK(pocketSaving);
    }

    /**
     * 포켓 조회
     *
     * @param memberUuid
     * @return PocketResponse : 누적 금액, 누적 기부 금액, 누적 탄소중립포인트, 누적 잔금 저축 금액
     */
    @GetMapping("/pocket")
    public ApiResponse<PocketResponse> getPocket(@RequestHeader String memberUuid){
        PocketResponse response = pocketQueryService.getPocket(memberUuid);
        return ApiResponse.OK(response);
    }

    /**
     * 포켓 전체 상세 조회
     */
    @GetMapping("/pocket/detail")
    public ApiResponse<PocketDetailAllResponse> getPocketDetailAll(@RequestHeader String memberUuid){
        PocketDetailAllResponse response = pocketQueryService.getPocketDetailAll(memberUuid);
        return ApiResponse.OK(response);
    }

}
