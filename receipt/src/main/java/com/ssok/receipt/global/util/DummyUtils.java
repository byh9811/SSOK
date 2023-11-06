package com.ssok.receipt.global.util;

import com.ssok.receipt.global.enumerate.BankName;
import com.ssok.receipt.global.enumerate.CardName;
import com.ssok.receipt.global.enumerate.CardRate;
import org.springframework.stereotype.Component;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;

public class DummyUtils {

    static Random random = new Random();

    /**
     * 14자리의 랜덤 계좌번호 리턴
     *
     * @return 랜덤 계좌번호
     */
    public String getAccountNum() {
        StringBuilder accountNum = new StringBuilder();

        accountNum.append(random.nextInt(9) + 1);
        for(int i=0; i<14; i++) {
            accountNum.append(random.nextInt(10));
        }
        return accountNum.toString();
    }

    /**
     * 3년 이내의 랜덤 날짜 리턴
     *
     * @return 랜덤 날짜
     */
    public LocalDateTime getDate() {
        long randomLong = Math.abs(random.nextLong()) % 94672800000L;
        return LocalDateTime.now().minus(randomLong, ChronoUnit.MILLIS);
    }

    /**
     * 19자리의 랜덤 카드번호 리턴
     *
     * @return 랜덤 카드번호
     */
    public static String getCardNum() {
        StringBuilder cardNum = new StringBuilder();

        for(int i=1; i<20; i++) {
            if (i % 5 == 0) {
                cardNum.append('-');
            } else {
                cardNum.append(random.nextInt(10));
            }
        }

        return cardNum.toString();
    }

    /**
     * 랜덤 카드 이름 생성
     *
     * @return 랜덤 카드 이름
     */
    public static String getCardName() {
        StringBuilder cardName = new StringBuilder();
        cardName.append(CardName.valueOf(random.nextInt(5)))
                .append(' ')
                .append(CardRate.valueOf(random.nextInt(5)));

        return cardName.append(" 카드").toString();
    }

    /**
     * 랜덤 은행 이름 생성
     *
     * @return 랜덤 은행 이름
     */
    public static Integer getRandInt(int idx) {
        return random.nextInt(idx);
    }

    /**
     * "0X" 형태의 타입을 랜덤으로 생성
     *
     * @param max X의 최댓값
     * @return 타입
     */
    public static String getType(int max) {
        return "0" + (random.nextInt(max) + 1);
    }

    /**
     * 주어진 확률로 true를 반환한다.
     *
     * @param probability 확률
     * @return 확률에 선정되었는지 여부
     */
    public boolean drawLots(int probability) {
        return random.nextInt(100) < probability;
    }

}
