package com.ssok.idcard.domain.service;

import com.ssok.idcard.global.api.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Component
@FeignClient(name = "member-service", url = "https://member.ssok.site/api/member-service")
public interface MemberServiceClient {

    @GetMapping(value = "/member/seq")
    ApiResponse<Long> getMemberseq(@RequestParam("member-uuid") String uuid);

}
