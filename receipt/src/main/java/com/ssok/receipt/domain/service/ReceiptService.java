package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.inner.InnerPaymentItem;
import com.ssok.receipt.domain.maria.entity.PurchaseItem;
import com.ssok.receipt.domain.maria.entity.Receipt;
import com.ssok.receipt.domain.maria.repository.PurchaseItemRepository;
import com.ssok.receipt.domain.maria.repository.ReceiptRepository;
import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
import com.ssok.receipt.global.openfeign.member.MemberClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class ReceiptService {

    private final ReceiptEventHandler eventHandler;
    private final ReceiptRepository receiptRepository;
    private final PurchaseItemRepository purchaseItemRepository;
    private final MemberClient memberClient;

    public void createReceipt(ReceiptCreateServiceDto receiptCreateServiceDto) {
        Receipt receipt = Receipt.fromCreateDto(receiptCreateServiceDto);
        List<InnerPaymentItem> paymentItemList = receiptCreateServiceDto.paymentItemList();
        List<PurchaseItem> purchaseItemList = new ArrayList<>();
        List<String> carbonNeutralItemList = new ArrayList<>();     // DB or Enum에서 읽기
        for (InnerPaymentItem innerPaymentItem : paymentItemList) {
            boolean isCNI = false;
            for (String carbonNeutralItem : carbonNeutralItemList) {
                if (carbonNeutralItem.equals(innerPaymentItem.itemName())) {      // 이름으로 비교
                    isCNI = true;
                    break;
                }
            }

            purchaseItemList.add(PurchaseItem.from(receipt, innerPaymentItem, isCNI));
        }

        purchaseItemRepository.saveAll(purchaseItemList);
        receiptRepository.save(receipt);
        eventHandler.createReceipt(receiptCreateServiceDto);


    }

}
