package com.ssok.base.domain.api;

import com.ssok.base.domain.api.dto.request.DomainJoinRequest;
import com.ssok.base.domain.api.dto.response.DomainJoinResponse;
import com.ssok.base.domain.service.DomainQueryService;
import com.ssok.base.domain.service.DomainService;
import com.ssok.base.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import static com.ssok.base.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/domain")
public class DomainController {

    private final DomainService domainService;
    private final DomainQueryService domainQueryService;

    @PostMapping
    public ApiResponse<DomainJoinResponse> createDomain(
            @RequestBody DomainJoinRequest domainJoinRequest
    ) {
        return OK(new DomainJoinResponse("dummy", 20));
    }

    @GetMapping
    public ApiResponse<DomainJoinResponse> getDomain(
            @RequestBody DomainJoinRequest domainJoinRequest
    ) {
        return OK(new DomainJoinResponse("dummy", 20));
    }

}
