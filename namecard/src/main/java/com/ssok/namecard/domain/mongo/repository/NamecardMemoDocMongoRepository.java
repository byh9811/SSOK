package com.ssok.namecard.domain.mongo.repository;

import com.ssok.namecard.domain.mongo.document.NamecardMemoDoc;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NamecardMemoDocMongoRepository extends MongoRepository<NamecardMemoDoc, Long> {

    Optional<NamecardMemoDoc> findByMemberSeq(Long memberSeq);

    Optional<NamecardMemoDoc> findByMemberSeqAndExchangeSeq(Long memberSeq, Long exchangeSeq);

    Optional<NamecardMemoDoc> findByExchangeSeq(Long exchangeSeq);
}
