package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.response.ReceiptDetailQueryResponse;
import com.ssok.receipt.domain.api.dto.response.ReceiptListQueryResponse;
import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import com.ssok.receipt.domain.mongo.repository.ReceiptDetailDocumentRepository;
import com.ssok.receipt.domain.mongo.repository.ReceiptListDocumentRepository;
import com.ssok.receipt.domain.service.dto.ReceiptListQueryDto;
import com.ssok.receipt.global.openfeign.member.MemberClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class ReceiptQueryService {

    private final ReceiptListDocumentRepository receiptListDocumentRepository;
    private final ReceiptDetailDocumentRepository receiptDetailDocumentRepository;
    private final MemberClient memberClient;

    public List<ReceiptListQueryResponse> getReceiptList(String memberUUID) {
        Long memberSeq = memberClient.getMemberSeq(memberUUID).getResponse();
        List<ReceiptListDocument> receiptDocumentList = receiptListDocumentRepository.findAllByMemberSeq(memberSeq);

        return receiptDocumentList.stream().map(ReceiptListQueryResponse::from).collect(Collectors.toList());
    }

    public ReceiptDetailQueryResponse getReceiptDetail(String receiptDetailId) {
        return ReceiptDetailQueryResponse.from(receiptDetailDocumentRepository.findById(receiptDetailId).get());
    }

}
