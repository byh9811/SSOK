package com.ssok.mydata.global.openfeign.transaction;

import com.ssok.mydata.domain.card.api.dto.request.PayRequest;
import com.ssok.mydata.domain.pos.entity.Payment;
import com.ssok.mydata.global.api.ApiResult;
import com.ssok.mydata.global.config.OpenFeignConfig;
import com.ssok.mydata.global.openfeign.transaction.dto.request.CreateReceiptRequest;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(name = "transaction", url = "http://receipt.ssok.site/api/receipt-service/receipt", configuration = OpenFeignConfig.class)
public interface ReceiptClient {

    @PostMapping
    ApiResult<Void> saveNewTransaction(
            @RequestHeader("ACCESS-TOKEN") String token,
            @RequestBody CreateReceiptRequest request);
}
