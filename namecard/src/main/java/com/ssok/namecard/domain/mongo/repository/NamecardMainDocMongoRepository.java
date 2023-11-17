package com.ssok.namecard.domain.mongo.repository;


import com.ssok.namecard.domain.mongo.document.NamecardMainDoc;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NamecardMainDocMongoRepository extends MongoRepository<NamecardMainDoc, Long> {

    Optional<NamecardMainDoc> findByMemberSeq(Long memberSeq);

    Optional<NamecardMainDoc> findByNamecardSeq(Long namecardSeq);
}