package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.response.ReceiptJoinResponse;
import com.ssok.receipt.domain.maria.repository.ReceiptRepository;
import com.ssok.receipt.domain.service.dto.ReceiptDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class ReceiptService {

    private final ReceiptRepository receiptRepository;

    public ReceiptJoinResponse createReceipt(ReceiptDto receiptDto) {
        ReceiptJoinResponse receiptJoinResponse = new ReceiptJoinResponse(receiptDto.nickname(), receiptDto.age());
        return receiptJoinResponse;
    }

}
