package com.ssok.namecard.domain.mongo.repository;


import com.ssok.namecard.domain.mongo.document.NamecardMain;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NamecardMainMongoRepository extends MongoRepository<NamecardMain, Long> {

    Optional<NamecardMain> findByMemberSeq(Long memberSeq);
}