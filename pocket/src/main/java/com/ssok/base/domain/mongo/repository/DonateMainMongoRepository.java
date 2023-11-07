package com.ssok.base.domain.mongo.repository;

import com.ssok.base.domain.mongo.document.DonateMain;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface DonateMainMongoRepository extends MongoRepository<DonateMain, Long> {
//    List<DonateMain> findAllByOrderByDonateStateDesc();
    List<DonateMain> findAll(Sort sort);
}

