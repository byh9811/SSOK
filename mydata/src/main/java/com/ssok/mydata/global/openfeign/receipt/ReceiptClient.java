package com.ssok.mydata.global.openfeign.receipt;

import com.ssok.mydata.global.api.ApiResult;
import com.ssok.mydata.global.config.OpenFeignConfig;
import com.ssok.mydata.global.openfeign.receipt.dto.request.CreateReceiptRequest;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "transaction", url = "https://receipt.ssok.site/api/receipt-service/receipt", configuration = OpenFeignConfig.class)
public interface ReceiptClient {

    @PostMapping
    ApiResult<Void> saveNewTransaction(
            @RequestBody CreateReceiptRequest request);
}
