package com.ssok.namecard.client;

import org.springframework.cloud.openfeign.FeignClient;

@FeignClient(name = "member-service", url = "https://member.ssok.site")
public interface MemberServiceClient {



}
