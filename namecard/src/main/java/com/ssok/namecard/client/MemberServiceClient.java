package com.ssok.namecard.client;

import com.ssok.namecard.client.config.FeignConfig;
import com.ssok.namecard.global.api.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Component
@FeignClient(name = "member-service", url = "https://member.ssok.site", configuration = FeignConfig.class)
public interface MemberServiceClient {

    @GetMapping(produces = "application/json", value = "/member/seq")
    ApiResponse<Long> getMemberSeq(@RequestBody String memberUuid);
}
