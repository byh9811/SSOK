package com.ssok.base.client.config;

import com.ssok.base.client.config.req.AccountTransferRequest;
import com.ssok.base.global.api.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name= "receipt-service", url = "https://receipt.ssok.site/api/receipt-service")
public interface ReceiptServiceClient {
    @PostMapping(value = "/account/transfer")
    ApiResponse<?> accountTransfer(@RequestBody AccountTransferRequest request);
}
