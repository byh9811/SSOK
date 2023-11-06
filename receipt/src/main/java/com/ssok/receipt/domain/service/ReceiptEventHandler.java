package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.mongo.document.ReceiptDetailDocument;
import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import com.ssok.receipt.domain.mongo.repository.ReceiptDetailDocumentRepository;
import com.ssok.receipt.domain.mongo.repository.ReceiptListDocumentRepository;
import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ReceiptEventHandler {

    private final ReceiptListDocumentRepository receiptListDocumentRepository;
    private final ReceiptDetailDocumentRepository receiptDetailDocumentRepository;

    public void createReceipt(ReceiptCreateServiceDto receiptCreateServiceDto) {
        ReceiptDetailDocument receiptDetailDocument = receiptDetailDocumentRepository.save(ReceiptDetailDocument.fromCreateDto(receiptCreateServiceDto));
        ReceiptListDocument createDto = receiptListDocumentRepository.save(ReceiptListDocument.fromCreateDto(receiptDetailDocument.getReceiptDetailDocumentSeq(), receiptCreateServiceDto));
    }

}
