package com.ssok.member.domain.repository.mongo;

import com.ssok.member.domain.entity.MemberDoc;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberMongoRepository extends MongoRepository<MemberDoc, String> {
}
