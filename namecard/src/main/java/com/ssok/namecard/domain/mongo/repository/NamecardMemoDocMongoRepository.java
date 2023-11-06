package com.ssok.namecard.domain.mongo.repository;

import com.ssok.namecard.domain.mongo.document.NamecardMemoDoc;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NamecardMemoDocMongoRepository extends MongoRepository<NamecardMemoDoc, Long> {

    Optional<NamecardMemoDoc> findByExchangeSeq(Long exchangeSeq);
}
