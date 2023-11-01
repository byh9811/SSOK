package com.ssok.receipt.global.openfeign.otherhello;

import com.ssok.receipt.global.api.ApiResponse;
import com.ssok.receipt.global.config.OpenFeignConfig;
import com.ssok.receipt.global.openfeign.otherhello.dto.request.DomainFeignRequest;
import com.ssok.receipt.global.openfeign.otherhello.dto.response.DomainFeignResponse;
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
