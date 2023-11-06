package com.ssok.receipt.global.openfeign.mydata;

import com.ssok.receipt.global.config.OpenFeignConfig;
import com.ssok.receipt.global.openfeign.mydata.dto.request.CardCreateFeignRequest;
import com.ssok.receipt.global.openfeign.mydata.dto.response.CardCreateFeignResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "card", url = "https://k9c107.p.ssafy.io/mydata/auth-management/oauth/2.0", configuration = OpenFeignConfig.class)
public interface CardClient {

    @PostMapping("/register/card")
    ResponseEntity<CardCreateFeignResponse> registerCard(
            @RequestBody CardCreateFeignRequest request);
}
