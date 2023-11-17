package com.ssok.base.client.config;

import com.ssok.base.global.api.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(name = "member-service", url = "https://member.ssok.site/api/member-service")
public interface MemberServiceClient {

    @GetMapping(value = "/member/seq")
    ApiResponse<Long> getMemberSeq(@RequestParam("member-uuid") String uuid);

    @GetMapping(value = "/member/account")
    ApiResponse<String> getMemberAccount(@RequestParam("member-seq") Long memberSeq);

}
