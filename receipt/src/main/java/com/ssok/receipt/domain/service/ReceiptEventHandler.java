package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.mongo.document.Receipt;
import com.ssok.receipt.domain.mongo.repository.ReceiptMongoRepository;
import com.ssok.receipt.domain.service.dto.ReceiptCreateDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ReceiptEventHandler {

    private final ReceiptMongoRepository mongoRepository;

    public void createReceipt(ReceiptCreateDto receiptCreateDto) {
        Receipt receipt = Receipt.builder()
                .name(receiptCreateDto.nickname())
                .age(receiptCreateDto.age())
                .build();

        mongoRepository.save(receipt);
    }

}
