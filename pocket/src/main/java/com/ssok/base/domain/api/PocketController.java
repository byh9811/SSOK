package com.ssok.base.domain.api;

import com.ssok.base.domain.api.dto.request.DomainJoinRequest;
import com.ssok.base.domain.api.dto.response.DomainJoinResponse;
import com.ssok.base.domain.api.dto.response.PocketResponse;
import com.ssok.base.domain.maria.entity.Pocket;
import com.ssok.base.domain.service.PocketQueryService;
import com.ssok.base.domain.service.PocketService;
import com.ssok.base.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

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

}
