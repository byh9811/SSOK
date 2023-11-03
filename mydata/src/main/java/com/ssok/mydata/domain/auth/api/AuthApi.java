package com.ssok.mydata.domain.auth.api;

import com.ssok.mydata.domain.auth.api.dto.request.AuthRequest;
import com.ssok.mydata.domain.auth.api.dto.request.CardRequest;
import com.ssok.mydata.domain.auth.api.dto.request.TokenRequest;
import com.ssok.mydata.domain.auth.service.AuthService;
import com.ssok.mydata.domain.auth.api.dto.response.AuthResponse;
import com.ssok.mydata.domain.auth.api.dto.response.TokenResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/mydata/auth-management/oauth/2.0")
public class AuthApi {

    private final AuthService authService;

    @GetMapping("/authorize")
    public ResponseEntity<AuthResponse> getAuthCode(
            @RequestHeader("x-api-tran-id") String tranId,
            @ModelAttribute AuthRequest authRequest)
    {
        return new ResponseEntity<>(new AuthResponse(), HttpStatus.OK);
    }

    @PostMapping("/token")
    public ResponseEntity<? extends TokenResponse> getAccessToken(
            @RequestHeader("x-user-ci") String userCi,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestBody TokenRequest tokenRequest)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.add("x-api-tran-id", "1234567890M00000000000001");

//        if (userCI == null) {       // AT 갱신 로직
//            return new ResponseEntity<>(new TokenResponse(), headers, HttpStatus.TEMPORARY_REDIRECT);
//        } else {        // AT 발급 로직
            return new ResponseEntity<>(authService.getAccessToken(userCi), headers, HttpStatus.OK);
//        }

    }

    @PostMapping("/register/account")
    public ResponseEntity<Void> registerAccount(
            @RequestBody Map<String, String> body
    ) {
        HttpHeaders headers = new HttpHeaders();
        headers.add("x-api-tran-id", "1234567890M00000000000001");
        String userCi = body.get("user_ci");
        authService.registerAccount(userCi);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/register/card")
    public ResponseEntity<Void> registerCard(
            @RequestBody CardRequest cardRequest
    ) {
        HttpHeaders headers = new HttpHeaders();
        headers.add("x-api-tran-id", "1234567890M00000000000001");
        authService.registerCard(cardRequest);

        return new ResponseEntity<>(HttpStatus.OK);
    }

}
