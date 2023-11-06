package com.ssok.namecard.client;

import com.ssok.namecard.global.api.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Component
@FeignClient(name = "member-service", url = "https://member.ssok.site/api/member-service")
public interface MemberServiceClient {

    @GetMapping(value = "/member/seq")
    ApiResponse<Long> getMemberSeq(@RequestParam("member-uuid") String uuid);

}
