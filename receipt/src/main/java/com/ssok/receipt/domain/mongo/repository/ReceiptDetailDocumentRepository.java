package com.ssok.receipt.domain.mongo.repository;

import com.ssok.receipt.domain.mongo.document.ReceiptDetailDocument;
import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ReceiptDetailDocumentRepository extends MongoRepository<ReceiptDetailDocument, String> {

    Optional<ReceiptDetailDocument> findByApprovedNum(String approvedNum);

}