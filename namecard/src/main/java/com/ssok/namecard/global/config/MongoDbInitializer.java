package com.ssok.namecard.global.config;

import com.ssok.namecard.domain.mongo.document.NamecardDetailDoc;
import com.ssok.namecard.domain.mongo.document.NamecardMainDoc;
import com.ssok.namecard.domain.mongo.document.NamecardMapDoc;
import com.ssok.namecard.domain.mongo.document.NamecardMemoDoc;
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
        mongoTemplate.dropCollection(NamecardMainDoc.class);
        mongoTemplate.dropCollection(NamecardDetailDoc.class);
        mongoTemplate.dropCollection(NamecardMapDoc.class);
        mongoTemplate.dropCollection(NamecardMemoDoc.class);

        // 여기에서 추가적인 초기화 작업을 수행할 수 있습니다.
    }
}

