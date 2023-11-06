package com.ssok.receipt.global.openfeign.mydata.auth;

import com.ssok.receipt.global.openfeign.mydata.auth.dto.request.TokenRequest;
import com.ssok.receipt.global.openfeign.mydata.auth.dto.response.TokenResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.HashMap;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class AuthAccessUtil {

    private final AuthClient authClient;

    private String orgCode = "ssok";

    public String getMydataAccessToken(String memberCi) {
        TokenResponse tokenResponse = authClient.getAccessToken(
                        memberCi,
                        getTranId(),
                        createTokenRequest())
                .getBody();

        if (tokenResponse == null) {
            throw new RuntimeException("토큰 정보를 얻을 수 없습니다!!");
        }

        return tokenResponse.getAccess_token();
    }

    private String getApiType() {
        return "user-search";
    }

    private String getTranId() {
        return "1234567890M00000000000001";
    }

    private TokenRequest createTokenRequest() {
        return TokenRequest.builder()
                .org_code(orgCode)
                .grant_type("authorization_code")
                .client_id("ssok")
                .client_secret("ssokSecretPassword")
                .redirect_uri("https://j9c211.p.ssafy.io/blahblah")
                .build();
    }

}
