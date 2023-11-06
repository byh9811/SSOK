package com.ssok.base.domain.mongo.repository;

import com.ssok.base.domain.mongo.document.PocketMain;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface PocketMainMongoRepository extends MongoRepository<PocketMain, Long> {
}
