package com.ssok.base.domain.api;

import com.ssok.base.domain.api.dto.request.DonateRequest;
import com.ssok.base.domain.service.DonateService;
import com.ssok.base.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/donate-service")
public class DonateController {
    // Donate 생성
    private final DonateService donateService;

    @PostMapping("/donate")
    public ApiResponse<?> createDonate(@RequestHeader String memberUuid, @RequestBody DonateRequest request){
        donateService.doDonate(request.toDto(memberUuid));

        return ApiResponse.OK(null);
    }

}
