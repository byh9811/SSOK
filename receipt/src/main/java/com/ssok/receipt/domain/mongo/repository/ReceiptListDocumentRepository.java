package com.ssok.receipt.domain.mongo.repository;

import com.ssok.receipt.domain.mongo.document.ReceiptDetailDocument;
import com.ssok.receipt.domain.mongo.document.ReceiptListDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ReceiptListDocumentRepository extends MongoRepository<ReceiptListDocument, String> {

//    @Query(value = "{ 'approvedDate' : { $gte: ?0, $lt: ?1 } }")
//    List<ReceiptListDocument> findAllByApprovedDate(LocalDateTime start, LocalDateTime end);

    List<ReceiptListDocument> findAllByMemberSeqOrderByApprovedDateDesc(Long memberSeq);

}