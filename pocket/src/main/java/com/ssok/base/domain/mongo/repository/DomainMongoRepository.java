package com.ssok.base.domain.mongo.repository;

import com.ssok.base.domain.mongo.document.Domain;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface DomainMongoRepository extends MongoRepository<Domain, String> {

}