package com.ssok.mydata.domain.auth.service;

import com.ssok.mydata.domain.bank.entity.Account;
import com.ssok.mydata.domain.bank.repository.AccountRepository;
import com.ssok.mydata.domain.auth.api.dto.response.TokenCreateResponse;
import com.ssok.mydata.domain.auth.entity.Auth;
import com.ssok.mydata.domain.auth.repository.AuthRepository;
import com.ssok.mydata.domain.card.entity.Card;
import com.ssok.mydata.domain.card.entity.CardHistory;
import com.ssok.mydata.domain.card.repository.CardHistoryRepository;
import com.ssok.mydata.domain.card.repository.CardRepository;
import com.ssok.mydata.global.enumerate.Shop;
import com.ssok.mydata.global.util.DummyUtils;
import com.ssok.mydata.global.util.JwtUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;


@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final AuthRepository authRepository;
    private final AccountRepository accountRepository;
    private final CardRepository cardRepository;
    private final CardHistoryRepository cardHistoryRepository;
    private final JwtUtils jwtUtils;
    private final DummyUtils dummyUtils;

    public void registerToken(long userCi) {
        if (authRepository.existsById(userCi)) {
            log.warn("이미 이 회원에 대해 더미데이터를 생성했습니다!!");
            return;
        }

        // 인증 정보 저장
        authRepository.save(
                Auth.builder()
                        .id(userCi)
                        .build());

        // 계좌 5개 생성
        List<Account> accountList = new ArrayList<>();
        for(int i=0; i<5; i++) {
            Date date = dummyUtils.getDate();
            Account account = Account.builder()
                    .memberCi(userCi)
                    .bank(dummyUtils.getBankName())
                    .prodName(dummyUtils.getAccountName())
                    .issueDate(date)
                    .accountNum(dummyUtils.getAccountNum())
                    .currencyCode("KRW")
                    .savingMethod(dummyUtils.getType(2))
                    .offeredRate(0.1)
                    .balanceAmt(10000000.0)
                    .withdrawableAmt(10000000.0)
                    .expDate(new Date(date.getTime() + 157788000000L))
                    .build();
            accountList.add(account);
        }
        accountList = accountRepository.saveAll(accountList);

        // 카드 4개 생성
        List<Card> cardList = new ArrayList<>();
        for (int i = 0; i < 4; i++) {
            Card card = Card.builder()
                    .memberCi(userCi)
                    .cardCompany(dummyUtils.getBankName(i+1))
                    .accountId(accountList.get(i).getId())
                    .cardNum(dummyUtils.getCardNum())
                    .isConsent(true)
                    .cardName(dummyUtils.getCardName())
                    .cardMember(1)
                    .cardType(dummyUtils.getType(3))
                    .annualFee(100000L)
                    .issueDate(new Date().getTime())
                    .build();
            cardList.add(card);
        }
        cardRepository.saveAll(cardList);

        // 15% 확률로 카드 내역 생성
        for (int i = 60; i > 0; i--) {
            for (int j = 0; j < 24; j++) {
                boolean result = dummyUtils.drawLots(15);
                if (result) {
                    Shop shop = dummyUtils.getShop();
                    Date payTime = new Date(new Date().getTime() - (i * 86400000L) + (j * 3600000));
                    Card card = cardList.get(new Random().nextInt(4));
                    CardHistory cardHistory = CardHistory.builder()
                            .card(card)
                            .approvedNum("12345678")
                            .approvedDtime(payTime)
                            .status("01")
                            .payType(dummyUtils.getType(2))
                            .merchantName(shop.name())
                            .merchantRegno(shop.getRegistrationNumber())
                            .approvedAmt(dummyUtils.getPayAmt())
                            .build();

                    cardHistoryRepository.save(cardHistory);
                }
            }
        }
    }

    public TokenCreateResponse getAccessToken(long userId) {
        if(!authRepository.existsById(userId)) {
            throw new RuntimeException("등록되지 않은 회원입니다!!");
        }

        String accessToken = jwtUtils.createAccessToken(userId);
        String refreshToken = jwtUtils.createRefreshToken(userId);

        return TokenCreateResponse.builder()
                .tokenType("Bearer")
                .accessToken(accessToken)
                .expiresIn(jwtUtils.getAccessTokenValid())
                .refreshToken(refreshToken)
                .refreshTokenExpiresIn(jwtUtils.getRefreshTokenValid())
                .scope("bank.list bank.deposit card.list card.card")
                .build();
    }
}
