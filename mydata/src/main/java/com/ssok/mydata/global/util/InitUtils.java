package com.ssok.mydata.global.util;

import com.ssok.mydata.domain.pos.entity.Item;
import com.ssok.mydata.domain.pos.repository.ItemRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;

@Configuration
//@Profile({"local"})
@Slf4j
public class InitUtils {

    private final boolean setDummy = true;        // true 일때 더미 데이터 삽입

    @Bean
    CommandLineRunner init(
            ItemRepository itemRepository
    ){
        return args -> {
            if(!setDummy){
                return;
            }

            // 상품 데이터
            ArrayList<Item> items = new ArrayList<>();
            items.add(new Item(1L, "광동 옥수수 수염차 [500mL]", 1500L, "469"));
            items.add(new Item(2L, "무농약 백미 4kg", 15900L, "480"));
            items.add(new Item(3L, "쑥소쿰 주방 세제 750 mL (용기)", 6390L, "487"));
            items.add(new Item(4L, "단감 (2kg/두레인증)", 13900L, "529"));
            items.add(new Item(5L, "일회용 수저 세트", 3500L, "1034"));
            items.add(new Item(6L, "종이컵 30입", 2000L, "1238"));
            items.add(new Item(7L, "캠핑용 일회용 그릇 10개", 1500L, "1365"));
            items.add(new Item(8L, "일회용 면도기", 400L, "1590"));

            itemRepository.saveAll(items);
        };
    }

}