package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.response.ReceiptJoinResponse;
import com.ssok.receipt.domain.mongo.repository.ReceiptMongoRepository;
import com.ssok.receipt.domain.service.dto.ReceiptDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class ReceiptQueryService {

    private final ReceiptMongoRepository receiptMongoRepository;

    public ReceiptJoinResponse getReceipt(ReceiptDto receiptDto) {
        ReceiptJoinResponse receiptJoinResponse = new ReceiptJoinResponse(receiptDto.nickname(), receiptDto.age());
        return receiptJoinResponse;
    }

}
