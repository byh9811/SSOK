package com.ssok.mydata.domain.bank.api;

import com.ssok.mydata.domain.bank.api.dto.request.*;
import com.ssok.mydata.domain.bank.api.dto.response.*;
import com.ssok.mydata.domain.bank.service.AccountQueryService;
import com.ssok.mydata.domain.bank.service.AccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/mydata/account-management/accounts")
public class AccountApi {

    private final AccountQueryService accountQueryService;
    private final AccountService accountService;

    @GetMapping
    public ResponseEntity<AccountListResponse> getAccountList(
            @AuthenticationPrincipal User user,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @Valid @ModelAttribute AccountListRequest accountListRequest)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.add("x-api-tran-id", "1234567890M00000000000001");
        AccountListResponse response = accountQueryService.findAccountList(user.getUsername(), accountListRequest.getNext_page(), accountListRequest.getLimit());
        return new ResponseEntity<>(response, headers, HttpStatus.OK);
    }

    @PostMapping("/deposit/basic")
    public ResponseEntity<AccountInfoResponse> getAccountInfo(
            @AuthenticationPrincipal User user,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @Valid @RequestBody AccountInfoRequest accountInfoRequest)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.add("x-api-tran-id", "1234567890M00000000000001");
        AccountInfoResponse response = accountQueryService.findAccountInfo(accountInfoRequest.getAccountNum());
        return new ResponseEntity<>(response, headers, HttpStatus.OK);
    }

    @PostMapping("/deposit/detail")
    public ResponseEntity<AccountDetailResponse> getAccountDetail(
            @AuthenticationPrincipal User user,
            @RequestHeader("x-api-tran-id") String tranId,
            @RequestHeader("x-api-type") String type,
            @Valid @RequestBody AccountDetailRequest accountDetailRequest)
    {
        HttpHeaders headers = new HttpHeaders();
        headers.add("x-api-tran-id", "1234567890M00000000000001");
        AccountDetailResponse detail = accountQueryService.findAccountDetail(accountDetailRequest.getAccountNum());
        return new ResponseEntity<>(detail, headers, HttpStatus.OK);
    }

    // 계좌 입출금내역 조회
//    @PostMapping("/deposit/transactions")
//    public ResponseEntity<AccountTransactionListResponse> getTransactions(
//            @AuthenticationPrincipal User user,
//            @RequestHeader("x-api-tran-id") String tranId,
//            @RequestHeader("x-api-type") String type,
//            @Valid @RequestBody AccountTransactionListRequest accountTransactionListRequest)
//    {
//        log.info("{}", accountTransactionListRequest.getOrgCode());
//        HttpHeaders headers = new HttpHeaders();
//        headers.add("x-api-tran-id", "1234567890M00000000000001");
//        AccountTransactionListResponse ret = new AccountTransactionListResponse();
//        List<AccountTransactionList> list = new ArrayList<>();
//        list.add(new AccountTransactionList());
//        ret.setTransList(list);
//        return new ResponseEntity<>(ret, headers, HttpStatus.OK);
//    }

    @PostMapping("/charge")
    public ResponseEntity<ChargeResponse> charge(
            @Valid @RequestBody ChargeRequest chargeRequest)
    {
        accountService.charge(chargeRequest.getSenderAccNum(), chargeRequest.getTransAmt());
        return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @PostMapping("/transfer")
    public ResponseEntity<TransferResponse> transfer(
            @Valid @RequestBody TransferRequest transferRequest)
    {
        accountService.transfer(transferRequest.getReceiverAccNum(), transferRequest.getTransAmt());
        return new ResponseEntity<>(null, HttpStatus.OK);
    }

}
