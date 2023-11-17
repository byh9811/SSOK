package com.ssok.base.domain.mongo.repository;

import com.ssok.base.domain.mongo.document.DonateMemberDoc;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface DonateMemberDocMongoRepository extends MongoRepository<DonateMemberDoc, String> {
    DonateMemberDoc findByDonateSeqAndMemberSeq(Long donateSeq, Long memberSeq);
    List<DonateMemberDoc> findByMemberSeq(Long memberSeq);

    List<DonateMemberDoc> findAllByMemberSeq(Long memberSeq);
}
