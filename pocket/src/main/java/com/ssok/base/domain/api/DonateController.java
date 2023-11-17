package com.ssok.base.domain.api;

import com.ssok.base.domain.api.dto.request.DonateCreateRequest;
import com.ssok.base.domain.api.dto.request.DonateRequest;
import com.ssok.base.domain.api.dto.response.DonatesResponse;
import com.ssok.base.domain.service.DonateQueryService;
import com.ssok.base.domain.service.DonateService;
import com.ssok.base.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/pocket-service/donate")
public class DonateController {
    // Donate 생성
    private final DonateService donateService;
    private final DonateQueryService donateQueryService;

    @PostMapping("/init")
    public ApiResponse<Long> createDonate(@RequestHeader(name = "MEMBER-UUID") String memberUuid, @RequestBody DonateCreateRequest request){
        return ApiResponse.OK(donateService.createDonate(request));
    }

    @PostMapping()
    public ApiResponse<?> doDonate(@RequestHeader(name = "MEMBER-UUID") String memberUuid, @RequestBody DonateRequest request){
        log.info("들어왔습니다..");
        donateService.doDonate(request.toDto(memberUuid));
        return ApiResponse.OK(null);
    }

    @GetMapping()
    public ApiResponse<List<DonatesResponse>> getDonates(@RequestHeader(name = "MEMBER-UUID") String memberUuid){

        List<DonatesResponse> response = donateQueryService.getDonates(memberUuid);
        return ApiResponse.OK(response);
    }
}
