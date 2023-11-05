package com.ssok.mydata.domain.pos.service;

import com.ssok.mydata.domain.card.api.dto.request.PayRequest;
import com.ssok.mydata.domain.card.api.dto.response.PayResponse;
import com.ssok.mydata.domain.card.service.CardService;
import com.ssok.mydata.domain.pos.api.dto.inner.InnerPaymentItem;
import com.ssok.mydata.domain.pos.api.dto.request.PosPayRequest;
import com.ssok.mydata.domain.pos.entity.Item;
import com.ssok.mydata.domain.pos.entity.Payment;
import com.ssok.mydata.domain.pos.entity.PaymentItem;
import com.ssok.mydata.domain.pos.repository.ItemRepository;
import com.ssok.mydata.domain.pos.repository.PaymentItemRepository;
import com.ssok.mydata.domain.pos.repository.PaymentRepository;
import com.ssok.mydata.global.openfeign.transaction.ReceiptClient;
import com.ssok.mydata.global.openfeign.transaction.dto.request.CreateReceiptRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final PaymentItemRepository paymentItemRepository;
    private final ItemRepository itemRepository;
    private final ReceiptClient receiptClient;
    private final CardService cardService;

    public void pay(String memberCi, PosPayRequest posPayRequest) {
        PayRequest payRequest = posPayRequest.toPayRequest();

        // 카드 서버로 결제 수행
        PayResponse response = cardService.pay(memberCi, payRequest);

        // 포스 서버에 결제 내역 저장
        Payment payment = paymentRepository.save(posPayRequest.toPayment(response.getApprovedNum(), response.getApprovedDtime()));

        List<PaymentItem> paymentItemList = new ArrayList<>();
        List<InnerPaymentItem> receivedItemList = posPayRequest.getPaymentItemList();
        for (InnerPaymentItem innerPaymentItem : receivedItemList) {
            // 1. ItemSeq를 이용해서 Item 정보 읽기
            Item item = itemRepository.findById(innerPaymentItem.getItemSeq()).get();

            // 2. Payment와 Item 정보로 PaymentItem 객체 만들기
            PaymentItem paymentItem = PaymentItem.builder()
                    .payment(payment)
                    .item(item)
                    .paymentItemName(item.getItemName())
                    .paymentItemPrice(item.getItemPrice())
                    .paymentItemCnt(innerPaymentItem.getPaymentItemCnt())
                    .build();

            // 3. PaymentItem 객체 저장
            paymentItemList.add(paymentItem);
        }

        // bulk insert
        paymentItemRepository.saveAll(paymentItemList);

        // 쏙 영수증 서버로 결제 내역 송신
        CreateReceiptRequest createReceiptRequest = CreateReceiptRequest.fromEntity(payRequest.getCardId(), payment, paymentItemList);
        receiptClient.saveNewTransaction(posPayRequest.getAccessToken(), createReceiptRequest);
    }

}
