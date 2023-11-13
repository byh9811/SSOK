package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.response.ReceiptDetailQueryResponse;
import com.ssok.receipt.domain.api.dto.response.ReceiptListQueryResponse;
import com.ssok.receipt.domain.api.dto.response.ReceiptListQueryResponses;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class ReceiptQueryService {

    private final ReceiptListDocumentRepository receiptListDocumentRepository;
    private final ReceiptDetailDocumentRepository receiptDetailDocumentRepository;
    private final MemberClient memberClient;

    public ReceiptDetailQueryResponse getReceiptDetail(String receiptDetailId) {
        return ReceiptDetailQueryResponse.from(receiptDetailDocumentRepository.findById(receiptDetailId).get());
    }

    public Map<YearMonth, ReceiptListQueryResponses> getReceiptList(String memberUUID) {
        Map<YearMonth, List<ReceiptListQueryResponse>> receiptListMap = new HashMap<>();

        Long memberSeq = memberClient.getMemberSeq(memberUUID).getResponse();
        List<ReceiptListDocument> receiptDocumentList = receiptListDocumentRepository.findAllByMemberSeqOrderByApprovedDateDesc(memberSeq);

        if(receiptDocumentList.size() == 0){
            throw new IllegalArgumentException("상세 내역이 없습니다.");
        }

        // 월별로 나누기
        for(ReceiptListDocument receiptDocument : receiptDocumentList) {
            YearMonth yearMonth = YearMonth.from(receiptDocument.getApprovedDate());
            if (!receiptListMap.containsKey(yearMonth)) {
                receiptListMap.put(yearMonth, new ArrayList<>());
            }
            receiptListMap.get(yearMonth).add(ReceiptListQueryResponse.from(receiptDocument));
        }

        Map<YearMonth, ReceiptListQueryResponses> result = new HashMap<>();
        // 월 별 계산 로직
        for(Map.Entry<YearMonth, List<ReceiptListQueryResponse>> entry : receiptListMap.entrySet()){
            YearMonth key = entry.getKey();
            List<ReceiptListQueryResponse> value = entry.getValue();

            Long monthlyPay = 0L;
            for(ReceiptListQueryResponse response : value){
                monthlyPay += response.payAmt();
            }

            result.put(key, ReceiptListQueryResponses.builder()
                    .receiptListQueryResponses(value)
                    .totalHistory(value.size())
                    .totalPay(monthlyPay)
                    .build());
        }
        return result;
    }
}
