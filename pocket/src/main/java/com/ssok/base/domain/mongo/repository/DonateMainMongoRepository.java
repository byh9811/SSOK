package com.ssok.base.domain.mongo.repository;

import com.ssok.base.domain.mongo.document.DonateMain;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface DonateMainMongoRepository extends MongoRepository<DonateMain, Long> {
}
