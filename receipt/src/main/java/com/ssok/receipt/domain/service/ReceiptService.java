package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.inner.InnerPaymentItem;
import com.ssok.receipt.domain.maria.entity.PurchaseItem;
import com.ssok.receipt.domain.maria.entity.Receipt;
import com.ssok.receipt.domain.maria.repository.PurchaseItemRepository;
import com.ssok.receipt.domain.maria.repository.ReceiptRepository;
import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
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

    public void createReceipt(ReceiptCreateServiceDto receiptCreateServiceDto) {
        Receipt receipt = Receipt.fromCreateDto(receiptCreateServiceDto);
        List<InnerPaymentItem> paymentItemList = receiptCreateServiceDto.paymentItemList();
        List<PurchaseItem> purchaseItemList = new ArrayList<>();
        for (InnerPaymentItem innerPaymentItem : paymentItemList) {
            purchaseItemList.add(PurchaseItem.from(receipt, innerPaymentItem));
        }

        purchaseItemRepository.saveAll(purchaseItemList);
        receiptRepository.save(receipt);
        eventHandler.createReceipt(receiptCreateServiceDto);
    }

}
