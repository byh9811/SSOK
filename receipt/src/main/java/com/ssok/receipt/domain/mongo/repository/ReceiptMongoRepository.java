package com.ssok.receipt.domain.mongo.repository;

import com.ssok.receipt.domain.mongo.document.Receipt;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface ReceiptMongoRepository extends MongoRepository<Receipt, String> {

    List<Receipt> findAllByNameAndAge(String name, int age);

}