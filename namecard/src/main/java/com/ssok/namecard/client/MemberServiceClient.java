package com.ssok.namecard.client;

import com.ssok.namecard.client.request.MemberUuidRequest;
import com.ssok.namecard.client.response.MemberSeqResponse;
import com.ssok.namecard.global.api.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Component
@FeignClient(name = "member-service", url = "https://member.ssok.site/api/member-service")
public interface MemberServiceClient {

    @GetMapping(produces = "application/json", value = "/member/seq")
    ApiResponse<MemberSeqResponse> getMemberSeq(@RequestBody MemberUuidRequest memberUuid);
}
