package com.ssok.receipt.domain.api;

import com.ssok.receipt.domain.api.dto.request.ReceiptCreateRequest;
import com.ssok.receipt.domain.api.dto.request.ReceiptQueryRequest;
import com.ssok.receipt.domain.api.dto.response.ReceiptDetailQueryResponse;
import com.ssok.receipt.domain.api.dto.response.ReceiptListQueryResponse;
import com.ssok.receipt.domain.service.ReceiptQueryService;
import com.ssok.receipt.domain.service.ReceiptService;
import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
import com.ssok.receipt.domain.service.dto.ReceiptListQueryDto;
import com.ssok.receipt.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.ssok.receipt.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/receipt-service/receipt")
public class ReceiptController {

    private final ReceiptService receiptService;
    private final ReceiptQueryService receiptQueryService;

    @PostMapping
    public ApiResponse<Void> createReceipt(
            @RequestBody ReceiptCreateRequest receiptCreateRequest
    ) {
        receiptService.createReceipt(ReceiptCreateServiceDto.fromRequest(receiptCreateRequest));
        return OK(null);
    }

    @GetMapping("/list")
    public ApiResponse<List<ReceiptListQueryResponse>> getReceiptList(
            @RequestHeader String memberUUID
    ) {
        List<ReceiptListQueryResponse> receiptList = receiptQueryService.getReceiptList(memberUUID);
        return OK(receiptList);
    }

    @GetMapping("/{id}")
    public ApiResponse<ReceiptDetailQueryResponse> getReceiptDetail(
            @PathVariable("id") String id
    ) {
        ReceiptDetailQueryResponse receiptDetail = receiptQueryService.getReceiptDetail(id);
        return OK(receiptDetail);
    }

}
