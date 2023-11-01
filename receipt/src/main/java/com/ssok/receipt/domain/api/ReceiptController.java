package com.ssok.receipt.domain.api;

import com.ssok.receipt.domain.api.dto.request.ReceiptJoinRequest;
import com.ssok.receipt.domain.api.dto.response.ReceiptJoinResponse;
import com.ssok.receipt.domain.service.ReceiptQueryService;
import com.ssok.receipt.domain.service.ReceiptService;
import com.ssok.receipt.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import static com.ssok.receipt.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/receipt")
public class ReceiptController {

    private final ReceiptService receiptService;
    private final ReceiptQueryService receiptQueryService;

    @PostMapping
    public ApiResponse<ReceiptJoinResponse> createReceipt(
            @RequestBody ReceiptJoinRequest receiptJoinRequest
    ) {
        return OK(new ReceiptJoinResponse("dummy", 20));
    }

    @GetMapping("/{id}")
    public ApiResponse<ReceiptJoinResponse> getReceipt(
            @PathVariable("id") String
            @RequestBody ReceiptJoinRequest receiptJoinRequest
    ) {
        return OK(new ReceiptJoinResponse("dummy", 20));
    }

}
