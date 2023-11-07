package com.ssok.receipt.global.util;

import com.ssok.receipt.domain.maria.entity.EcoItem;
import com.ssok.receipt.domain.maria.repository.EcoItemRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;

@Configuration
//@Profile({"local"})
@Slf4j
public class initUtils {

    private final boolean setDummy = true;        // true 일때 더미 데이터 삽입

    @Bean
    CommandLineRunner init(
            EcoItemRepository ecoItemRepository
    ){
        return args -> {
            if(!setDummy){
                return;
            }

            // 친환경 상품 데이터
            ArrayList<EcoItem> ecoItems = new ArrayList<>();
            ecoItems.add(new EcoItem("469", "광동제약(주)", "광동 옥수수 수염차 [500mL]", 80L, "환경성적"));
            ecoItems.add(new EcoItem("480", "군자농협 잡곡소포장공장(가공)", "무농약 백미 4kg", 760L, "친환경인증농산물"));
            ecoItems.add(new EcoItem("487", "네이처홀드", "쑥소쿰 주방 세제 750 mL (용기)", 1120L, "친환경인증농산물"));
            ecoItems.add(new EcoItem("529", "두레생협", "단감 (2kg/두레인증)", 2010L, "저탄소농산물"));

            ecoItemRepository.saveAll(ecoItems);
        };
    }

}