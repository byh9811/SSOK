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
        List<InnerPaymentItem> paymentItemList = receiptCreateServiceDto.paymentItemList();
        List<PurchaseItem> purchaseItemList = new ArrayList<>();
        List<EcoItem> carbonNeutralItemList = ecoItemRepository.findAll();     // DB or Enum에서 읽기
        Long earnedCNP = 0L;
        for (InnerPaymentItem innerPaymentItem : paymentItemList) {
            boolean isCNI = false;
            for (EcoItem carbonNeutralItem : carbonNeutralItemList) {
                if (carbonNeutralItem.getEcoItemName().equals(innerPaymentItem.itemName())) {      // 이름으로 비교
                    isCNI = true;
                    earnedCNP += innerPaymentItem.itemPrice();
                    break;
                }
            }

            purchaseItemList.add(PurchaseItem.from(receipt, innerPaymentItem, isCNI));
        }

        // 카드와 연계된 memberSeq 획득
        Card card = cardRepository.findByCardNum(receiptCreateServiceDto.receiptCardNum()).get();
        Long memberSeq = card.getMemberSeq();
        String mdToken = memberClient.getMemberMyDataToken(memberSeq).getResponse();
        String account = memberClient.getMemberAccount(memberSeq).getResponse();

//        // 탄소 중립 포인트 적립 요청
//        if (earnedCNP > 0) {
//            PocketHistoryCreateRequest request = PocketHistoryCreateRequest.builder()
//                    .memberSeq(memberSeq)
//                    .receiptSeq(receipt.getReceiptSeq())
//                    .pocketHistoryType("CARBON")
//                    .pocketHistoryTransAmt(earnedCNP)
//                    .build();
//            pocketClient.createPocketHistory(request);
//        }
//
//        // 잔금 적립 요청
//        long remain = receipt.getReceiptAmount() % 1000;
//        remain = (remain != 0) ? 1000 - remain : 0;
//        long balance = (long) bankAccessUtil.getAccountDetail(mdToken, account).getBalanceAmt();
//        if (memberClient.getMemberSaving(memberSeq).getResponse() && remain > 0 && balance >= remain) {     // 잔금 적립 기능 활성화 여부 && 잔금 발생 여부 && 통장 잔액 존재 여부
//            PocketHistoryCreateRequest request = PocketHistoryCreateRequest.builder()
//                    .memberSeq(memberSeq)
//                    .receiptSeq(receipt.getReceiptSeq())
//                    .pocketHistoryType("CHANGE")
//                    .pocketHistoryTransAmt(remain)
//                    .build();
//            pocketClient.createPocketHistory(request);
//        }

        purchaseItemRepository.saveAll(purchaseItemList);
        receiptRepository.save(receipt);
        eventHandler.createReceipt(memberSeq, receiptCreateServiceDto);
    }

}
