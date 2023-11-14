package com.ssok.receipt.domain.service;

import com.ssok.receipt.domain.api.dto.inner.InnerPaymentItem;
import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.entity.EcoItem;
import com.ssok.receipt.domain.maria.entity.PurchaseItem;
import com.ssok.receipt.domain.maria.entity.Receipt;
import com.ssok.receipt.domain.maria.repository.CardRepository;
import com.ssok.receipt.domain.maria.repository.EcoItemRepository;
import com.ssok.receipt.domain.maria.repository.PurchaseItemRepository;
import com.ssok.receipt.domain.maria.repository.ReceiptRepository;
import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
import com.ssok.receipt.global.api.ApiResponse;
import com.ssok.receipt.global.openfeign.member.MemberClient;
import com.ssok.receipt.global.openfeign.mydata.bank.BankAccessUtil;
import com.ssok.receipt.global.openfeign.pocket.PocketClient;
import com.ssok.receipt.global.openfeign.pocket.dto.request.PocketHistoryCreateRequest;
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
    private final CardRepository cardRepository;
    private final BankAccessUtil bankAccessUtil;
    private final PocketClient pocketClient;
    private final MemberClient memberClient;
    private final EcoItemRepository ecoItemRepository;

    public void createReceipt(ReceiptCreateServiceDto receiptCreateServiceDto) {
        Receipt receipt = Receipt.fromCreateDto(receiptCreateServiceDto);

        // 카드와 연계된 정보 획득
        Card card = cardRepository.findByCardNum(receiptCreateServiceDto.receiptCardNum()).get();
        Long memberSeq = card.getMemberSeq();
        String mdToken = memberClient.getMemberMyDataToken(memberSeq).getResponse();
        String account = memberClient.getMemberAccount(memberSeq).getResponse();

        // 결제
        bankAccessUtil.pay(mdToken, account, receipt.getReceiptAmount());
        receipt = receiptRepository.save(receipt);

        // 탄소 중립 포인트 계산
        List<InnerPaymentItem> paymentItemList = receiptCreateServiceDto.paymentItemList();
        List<PurchaseItem> purchaseItemList = new ArrayList<>();
        List<EcoItem> carbonNeutralItemList = ecoItemRepository.findAll();     // DB or Enum에서 읽기
        Long earnedCNP = 100L;
        for (InnerPaymentItem innerPaymentItem : paymentItemList) {
            boolean isCNI = false;
            for (EcoItem carbonNeutralItem : carbonNeutralItemList) {
                if (carbonNeutralItem.getEcoItemName().equals(innerPaymentItem.itemName())) {      // 이름으로 비교
                    isCNI = true;
                    earnedCNP += carbonNeutralItem.getEcoItemPoint();
                    break;
                }
            }

            purchaseItemList.add(PurchaseItem.from(receipt, innerPaymentItem, isCNI));
        }
        purchaseItemRepository.saveAll(purchaseItemList);

        String savedDocId = eventHandler.createReceipt(card, memberSeq, receiptCreateServiceDto);

        PocketHistoryCreateRequest carbonRequest = PocketHistoryCreateRequest.builder()
                .memberSeq(memberSeq)
                .receiptDocumentId(savedDocId)
                .pocketHistoryType("CARBON")
                .pocketHistoryTransAmt(earnedCNP)
                .build();
        try {
            pocketClient.createPocketHistory(carbonRequest);
        } catch(Exception e) {
            log.info("포켓이 없어서 기록은 안했습니다~");
        }

        try {
            // 잔금 적립 계산
            long remain = receipt.getReceiptAmount() % 1000;
            remain = (remain != 0) ? 1000 - remain : 0;
            long balance = (long) bankAccessUtil.getAccountDetail(mdToken, account).getBalanceAmt();

            // 잔금 적립 기능 활성화 여부 && 잔금 발생 여부 && 통장 잔액 존재 여부
            if (pocketClient.getPocketSaving(memberSeq).getResponse() && remain > 0 && balance >= remain) {
                bankAccessUtil.pay(mdToken, account, remain);
                PocketHistoryCreateRequest changeRequest = PocketHistoryCreateRequest.builder()
                        .memberSeq(memberSeq)
                        .receiptDocumentId(savedDocId)
                        .pocketHistoryType("CHANGE")
                        .pocketHistoryTransAmt(remain)
                        .build();
                pocketClient.createPocketHistory(changeRequest);
            }

        } catch(Exception e) {
            log.info("포켓이 없어서 기록은 안했습니다~");
        }
    }

}
