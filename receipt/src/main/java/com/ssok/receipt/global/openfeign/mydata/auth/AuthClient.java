package com.ssok.receipt.global.openfeign.mydata.auth;

import com.ssok.receipt.global.config.OpenFeignConfig;
import com.ssok.receipt.global.openfeign.mydata.auth.dto.request.CardCreateFeignRequest;
import com.ssok.receipt.global.openfeign.mydata.auth.dto.request.TokenRequest;
import com.ssok.receipt.global.openfeign.mydata.auth.dto.response.TokenResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(name = "auth", url = "https://k9c107.p.ssafy.io/mydata/auth-management/oauth/2.0", configuration = OpenFeignConfig.class)
public interface AuthClient {

    @PostMapping("/register/card")
    ResponseEntity<String> registerCard(
            @RequestBody CardCreateFeignRequest request);

    @PostMapping("/token")
    ResponseEntity<TokenResponse> getAccessToken(
            @RequestHeader("x-user-ci") String userCi,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestBody TokenRequest tokenRequest);

}
