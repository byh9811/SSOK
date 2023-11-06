package com.ssok.mydata.domain.auth.service;

import com.ssok.mydata.domain.auth.api.dto.request.CardRequest;
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

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;


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

    public void registerAccount(String userCi) {
        Auth auth = getAuth(userCi);

        if (auth.getRegisteredAccount()) {
            log.warn("이미 이 회원에 대해 계좌 데이터를 생성했습니다!!");
            return;
        }

        // 인증 정보 저장
        auth.makeAccount();

        LocalDateTime dateTime = dummyUtils.getDate();
        Account account = Account.builder()
                .memberCi(userCi)
                .bank(dummyUtils.getBankName())
                .prodName(dummyUtils.getAccountName())
                .issueDate(dateTime)
                .accountNum(dummyUtils.getAccountNum())
                .currencyCode("KRW")
                .savingMethod(dummyUtils.getType(2))
                .offeredRate(0.1)
                .balanceAmt(10000000.0)
                .withdrawableAmt(10000000.0)
                .expDate(dateTime.plus(157788000000L, ChronoUnit.MILLIS))
                .build();

        accountRepository.save(account);
    }

    public String registerCard(CardRequest cardRequest) {
        String userCi = cardRequest.getUser_ci();
        Auth auth = getAuth(userCi);

        if (!auth.getRegisteredAccount()) {
            registerAccount(userCi);
        }

        if (auth.getRegisteredCard()) {
            log.warn("이미 이 회원에 대해 카드 데이터를 생성했습니다!!");
            return null;
        }

        // 인증 정보 저장
        auth.makeCard();

        Card card = Card.builder()
                .cardId(UUID.randomUUID().toString())
                .memberCi(userCi)
                .cardCompany(cardRequest.getCard_company())
                .accountId(accountRepository.findByMemberCi(userCi).get().getId())
                .cardNum(cardRequest.getCard_num())
                .isConsent(true)
                .cardName(cardRequest.getCard_name())
                .cardMember(cardRequest.getCard_member())
                .cardType(cardRequest.getCard_type())
                .annualFee(cardRequest.getAnnual_fee())
                .issueDate(cardRequest.getIssue_date())
                .build();

        card = cardRepository.save(card);

        // 15% 확률로 카드 내역 생성
        for (int i = 60; i > 0; i--) {
            for (int j = 0; j < 24; j++) {
                boolean result = dummyUtils.drawLots(15);
                if (result) {
                    Shop shop = dummyUtils.getShop();
                    LocalDateTime payTime = LocalDateTime.now()
                            .minusDays(i)
                            .plusHours(j);

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

        return card.getCardId();
    }

    private Auth getAuth(String userCi) {
        if (!authRepository.existsByMemberCi(userCi)) {
            return authRepository.save(
                    Auth.builder()
                            .memberCi(userCi)
                            .registeredAccount(false)
                            .registeredCard(false)
                            .build());
        }

        return authRepository.findByMemberCi(userCi).get();
    }

    public TokenCreateResponse getAccessToken(String userCi) {
        if(!authRepository.existsByMemberCi(userCi)) {
            throw new RuntimeException("등록되지 않은 회원입니다!!");
        }

        String accessToken = jwtUtils.createAccessToken(userCi);
        String refreshToken = jwtUtils.createRefreshToken(userCi);

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
