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
@RequestMapping("/api/donate-service")
public class DonateController {
    // Donate 생성
    private final DonateService donateService;
    private final DonateQueryService donateQueryService;

    @PostMapping()
    public ApiResponse<Long> createDonate(@RequestHeader String memberUuid, @RequestBody DonateCreateRequest request){
        return ApiResponse.OK(donateService.createDonate(request));
    }

    @PostMapping("/donate")
    public ApiResponse<?> doDonate(@RequestHeader String memberUuid, @RequestBody DonateRequest request){
        log.info("들어왔습니다..");
        donateService.doDonate(request.toDto(memberUuid));
        return ApiResponse.OK(null);
    }

    @GetMapping("/donate")
    public ApiResponse<List<DonatesResponse>> getDonates(@RequestHeader String memberUuid){
        List<DonatesResponse> response = donateQueryService.getDonates(memberUuid);
        return ApiResponse.OK(response);
    }
}
