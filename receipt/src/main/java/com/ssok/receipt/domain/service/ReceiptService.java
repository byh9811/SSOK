package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.response.ReceiptCreateResponse;
import com.ssok.receipt.domain.maria.entity.Receipt;
import com.ssok.receipt.domain.maria.repository.ReceiptRepository;
import com.ssok.receipt.domain.service.dto.ReceiptCreateDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class ReceiptService {

    private final ReceiptEventHandler eventHandler;
    private final ReceiptRepository receiptRepository;

    public void createReceipt(ReceiptCreateDto receiptCreateDto) {
        Receipt receipt = Receipt.builder()
                .name(receiptCreateDto.nickname())
                .age(receiptCreateDto.age())
                .build();

        receiptRepository.save(receipt);
        eventHandler.createReceipt(receiptCreateDto);
    }

}
