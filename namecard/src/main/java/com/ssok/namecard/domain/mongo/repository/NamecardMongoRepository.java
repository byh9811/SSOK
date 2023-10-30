package com.ssok.namecard.domain.mongo.repository;


import com.ssok.namecard.domain.mongo.document.Namecard;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NamecardMongoRepository extends MongoRepository<Namecard, String> {

}