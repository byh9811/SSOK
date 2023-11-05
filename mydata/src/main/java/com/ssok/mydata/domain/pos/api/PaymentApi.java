package com.ssok.mydata.domain.pos.api;

import com.ssok.mydata.domain.bank.api.dto.response.*;
import com.ssok.mydata.domain.pos.api.dto.request.PosPayRequest;
import com.ssok.mydata.domain.pos.api.dto.response.PosPayResponse;
import com.ssok.mydata.domain.pos.service.PaymentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/pos/payment-service/payment")
public class PaymentApi {

    private final PaymentService paymentService;

    @PostMapping
    public ResponseEntity<PosPayResponse> pay(
            @AuthenticationPrincipal User user,
            @RequestBody PosPayRequest posPayRequest
    )
    {
        paymentService.pay(user.getUsername(), posPayRequest);
        return new ResponseEntity<>(null, HttpStatus.OK);
    }

}
