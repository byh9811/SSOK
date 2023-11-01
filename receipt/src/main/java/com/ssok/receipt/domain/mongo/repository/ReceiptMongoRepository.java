package com.ssok.receipt.domain.mongo.repository;

import com.ssok.receipt.domain.mongo.document.Receipt;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ReceiptMongoRepository extends MongoRepository<Receipt, String> {

}