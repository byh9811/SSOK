package com.ssok.receipt.domain.api;

import com.ssok.receipt.domain.api.dto.request.TransferCreateRequest;
import com.ssok.receipt.domain.api.dto.response.AccountInfoResponse;
import com.ssok.receipt.domain.api.dto.response.CardAdminQueryResponse;
import com.ssok.receipt.domain.api.dto.response.CardQueryResponse;
import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.repository.CardRepository;
import com.ssok.receipt.domain.service.AccountQueryService;
import com.ssok.receipt.domain.service.CardQueryService;
import com.ssok.receipt.domain.service.CardService;
import com.ssok.receipt.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import static com.ssok.receipt.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/receipt-service/account")
@Slf4j
public class AccountController {

    private final AccountQueryService accountQueryService;

    @GetMapping
    public ApiResponse<AccountInfoResponse> getAccountInfo(
            @RequestHeader("MEMBER-UUID") String memberUUID
    ) {
        return OK(accountQueryService.getAccountInfo(memberUUID));
    }

    @PostMapping("/transfer")
    public ApiResponse<Long> transfer(
            @RequestBody TransferCreateRequest request
    ) {
        return OK(accountQueryService.transfer(request.memberSeq(), request.amt()));
    }

}
