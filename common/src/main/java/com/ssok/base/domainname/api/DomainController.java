package com.ssok.base.domainname.api;

import com.ssok.base.domainname.api.dto.request.DomainJoinRequest;
import com.ssok.base.domainname.api.dto.response.DomainJoinResponse;
import com.ssok.base.domainname.service.DomainService;
import com.ssok.base.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static com.ssok.base.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/domain")
public class DomainController {

    private final DomainService domainService;
    @Value("encr")
    private String testvalue;

    @PostMapping
    public ApiResponse<DomainJoinResponse> joinDomain(
            @RequestBody DomainJoinRequest domainJoinRequest
            ) {
        return OK(new DomainJoinResponse("dummy", 20));
    }

}
