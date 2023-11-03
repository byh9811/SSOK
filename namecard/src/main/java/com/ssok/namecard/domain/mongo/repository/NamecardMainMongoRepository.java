package com.ssok.namecard.domain.mongo.repository;


import com.ssok.namecard.domain.mongo.document.NamecardMain;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NamecardMainMongoRepository extends MongoRepository<NamecardMain, String> {

    NamecardMain findByMemberId(Long memberId);
}