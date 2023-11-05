package com.ssok.namecard.domain.mongo.repository;

import com.ssok.namecard.domain.mongo.document.NamecardDetailDoc;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NamecardDetailDocMongoRepository extends MongoRepository<NamecardDetailDoc, String> {

}
