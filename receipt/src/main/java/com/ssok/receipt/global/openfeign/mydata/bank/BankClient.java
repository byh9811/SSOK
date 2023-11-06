package com.ssok.receipt.global.openfeign.mydata.bank;

import com.ssok.receipt.global.config.OpenFeignConfig;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.request.*;
import com.ssok.receipt.global.openfeign.mydata.bank.dto.response.*;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(name = "bank", url = "https://k9c107.p.ssafy.io/mydata/account-management/accounts", configuration = OpenFeignConfig.class)
public interface BankClient {

    @GetMapping
    ResponseEntity<AccountListResponse> getAccountList(
            @RequestHeader("Authorization") String token,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @SpringQueryMap AccountListRequest accountListRequest);


    @PostMapping("/deposit/basic")
    ResponseEntity<AccountInfoResponse> getAccountInfo(
            @RequestHeader("Authorization") String token,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @RequestBody AccountInfoRequest accountInfoRequest);

    @PostMapping("/deposit/detail")
    ResponseEntity<AccountDetailResponse> getAccountDetail(
            @RequestHeader("Authorization") String token,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @RequestBody AccountDetailRequest accountDetailRequest);

    @PostMapping("/charge")
    ResponseEntity<ChargeResponse> charge(
            @RequestHeader("Authorization") String token,
            @RequestBody ChargeRequest chargeRequest);

    @PostMapping("/transfer")
    ResponseEntity<TransferResponse> transfer(
            @RequestHeader("Authorization") String token,
            @RequestBody TransferRequest transferRequest);

}
