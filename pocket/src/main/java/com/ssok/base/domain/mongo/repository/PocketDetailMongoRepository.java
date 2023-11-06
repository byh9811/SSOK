package com.ssok.base.domain.mongo.repository;

import com.ssok.base.domain.mongo.document.PocketDetail;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface PocketDetailMongoRepository extends MongoRepository<PocketDetail, Long> {
}
