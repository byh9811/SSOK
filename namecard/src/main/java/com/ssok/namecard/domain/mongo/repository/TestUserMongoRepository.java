package com.ssok.namecard.domain.mongo.repository;

import com.ssok.namecard.domain.mongo.document.Namecard;
import com.ssok.namecard.domain.mongo.document.TestUser;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface TestUserMongoRepository extends MongoRepository<TestUser, String> {

}
