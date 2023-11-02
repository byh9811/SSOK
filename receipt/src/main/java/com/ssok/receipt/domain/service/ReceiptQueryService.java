package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.response.ReceiptCreateResponse;
import com.ssok.receipt.domain.mongo.document.Receipt;
import com.ssok.receipt.domain.mongo.repository.ReceiptMongoRepository;
import com.ssok.receipt.domain.service.dto.ReceiptQueryDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class ReceiptQueryService {

    private final ReceiptMongoRepository receiptMongoRepository;

    public List<ReceiptCreateResponse> getReceiptList(ReceiptQueryDto receiptQueryDto) {
        List<Receipt> allByNameAndAge = receiptMongoRepository.findAllByNameAndAge(receiptQueryDto.nickname(), receiptQueryDto.age());
        return allByNameAndAge.stream().map(ReceiptCreateResponse::from).toList();
    }

}
