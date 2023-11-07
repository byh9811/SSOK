package com.ssok.base.domain.mongo.repository;

import com.ssok.base.domain.maria.entity.PocketHistoryType;
import com.ssok.base.domain.mongo.document.PocketDetail;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface PocketDetailMongoRepository extends MongoRepository<PocketDetail, Long> {
    List<PocketDetail> findAllByMemberSeqAndPocketHistoryTypeInOrderByCreateDateDesc(Long memberSeq, List<PocketHistoryType> pocketHistoryTypes);

    List<PocketDetail> findAllByMemberSeqOrderByCreateDateDesc(Long memberSeq);
}
