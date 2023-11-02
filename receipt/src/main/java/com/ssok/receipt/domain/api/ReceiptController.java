package com.ssok.receipt.domain.api;

import com.ssok.receipt.domain.api.dto.request.ReceiptCreateRequest;
import com.ssok.receipt.domain.api.dto.response.ReceiptCreateResponse;
import com.ssok.receipt.domain.service.ReceiptQueryService;
import com.ssok.receipt.domain.service.ReceiptService;
import com.ssok.receipt.domain.service.dto.ReceiptCreateDto;
import com.ssok.receipt.domain.service.dto.ReceiptQueryDto;
import com.ssok.receipt.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.ssok.receipt.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/receipt-service")
public class ReceiptController {

    private final ReceiptService receiptService;
    private final ReceiptQueryService receiptQueryService;

    @PostMapping
    public ApiResponse<ReceiptCreateResponse> createReceipt(
            @RequestBody ReceiptCreateRequest receiptCreateRequest
    ) {
        receiptService.createReceipt(ReceiptCreateDto.fromRequest(receiptCreateRequest));
        return OK(new ReceiptCreateResponse("dummy", 20));
    }

    @GetMapping
    public ApiResponse<List<ReceiptCreateResponse>> getReceiptList(
            @RequestBody ReceiptCreateRequest receiptCreateRequest
    ) {
        List<ReceiptCreateResponse> receiptList = receiptQueryService.getReceiptList(ReceiptQueryDto.fromRequest(receiptCreateRequest));
        return OK(receiptList);
    }

}
