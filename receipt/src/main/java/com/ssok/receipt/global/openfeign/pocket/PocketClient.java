package com.ssok.receipt.global.openfeign.pocket;

import com.ssok.receipt.global.api.ApiResponse;
import com.ssok.receipt.global.openfeign.member.dto.request.MydataAccessTokenFeignRequest;
import com.ssok.receipt.global.openfeign.member.dto.request.MydataAccountFeignRequest;
import com.ssok.receipt.global.openfeign.pocket.dto.request.PocketHistoryCreateRequest;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@Component
@FeignClient(name = "pocket-service", url = "https://pocket.ssok.site/api/pocket-service")
public interface PocketClient {

    @PostMapping(value = "/pocket/pos/history")
    ApiResponse<String> createPocketHistory(
            @RequestBody PocketHistoryCreateRequest request);

    @GetMapping(value = "/pocket/change-saving")
    ApiResponse<Boolean> getPocketSaving(@RequestParam("member-seq") Long memberSeq);

}
