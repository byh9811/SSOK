package com.ssok.domainname.domain.mongo.repository;

import com.ssok.domainname.domain.mongo.document.Domain;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface DomainMongoRepository extends MongoRepository<Domain, String> {

}