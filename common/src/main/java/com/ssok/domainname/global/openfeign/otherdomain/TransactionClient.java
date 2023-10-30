package com.ssok.domainname.global.openfeign.otherdomain;

import com.ssok.domainname.global.api.ApiResponse;
import com.ssok.domainname.global.config.OpenFeignConfig;
import com.ssok.domainname.global.openfeign.otherdomain.dto.request.DomainFeignRequest;
import com.ssok.domainname.global.openfeign.otherdomain.dto.response.DomainFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(name = "transaction", url = "${api.base-uri.taesan}/transactions", configuration = OpenFeignConfig.class)
public interface TransactionClient {

    @PostMapping("/domain/{id}")
    ApiResponse<DomainFeignResponse> getDomain(
            @RequestHeader("ACCESS-TOKEN") String token,
            @PathVariable("id") Long id,
            @RequestBody DomainFeignRequest history);
}
