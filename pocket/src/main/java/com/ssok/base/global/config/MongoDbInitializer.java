package com.ssok.base.global.config;

import com.ssok.base.domain.mongo.document.DonateMain;
import com.ssok.base.domain.mongo.document.DonateMemberDoc;
import com.ssok.base.domain.mongo.document.PocketDetail;
import com.ssok.base.domain.mongo.document.PocketMain;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class MongoDbInitializer implements CommandLineRunner {

    private final MongoTemplate mongoTemplate;
    @Override
    public void run(String... args) throws Exception {
        // 컬렉션 드랍
        mongoTemplate.dropCollection(DonateMain.class);
        mongoTemplate.dropCollection(DonateMemberDoc.class);
        mongoTemplate.dropCollection(PocketDetail.class);
        mongoTemplate.dropCollection(PocketMain.class);

        // 여기에서 추가적인 초기화 작업을 수행할 수 있습니다.
    }
}

