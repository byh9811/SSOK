package com.ssok.namecard.domain.mongo.repository;

import com.ssok.namecard.domain.mongo.document.NamecardDetail;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NamecardDetailMongoRepository extends MongoRepository<NamecardDetail, String> {

}
