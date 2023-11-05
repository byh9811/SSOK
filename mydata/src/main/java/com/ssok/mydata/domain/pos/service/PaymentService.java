package com.ssok.mydata.domain.pos.service;

import com.ssok.mydata.domain.card.api.dto.request.PayRequest;
import com.ssok.mydata.domain.card.api.dto.response.PayResponse;
import com.ssok.mydata.domain.card.service.CardService;
import com.ssok.mydata.domain.pos.api.dto.request.PosPayRequest;
import com.ssok.mydata.domain.pos.entity.Item;
import com.ssok.mydata.domain.pos.entity.Payment;
import com.ssok.mydata.domain.pos.repository.ItemRepository;
import com.ssok.mydata.domain.pos.repository.PaymentRepository;
import com.ssok.mydata.global.openfeign.transaction.ReceiptClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final ReceiptClient receiptClient;
    private final CardService cardService;

    public void pay(String memberCi, PosPayRequest posPayRequest) {
        PayRequest payRequest = posPayRequest.getPayRequest();

        // 카드 서버로 결제 수행
        PayResponse response = cardService.pay(memberCi, payRequest);

        // 포스 서버에 결제 내역 저장
        Payment payment = paymentRepository.save(payRequest.toEntity(response.getApprovedNum(), response.getApprovedDtime()));

        // 쏙 영수증 서버로 결제 내역 송신
        receiptClient.saveNewTransaction(posPayRequest.getAccessToken(), payment);
    }

}
