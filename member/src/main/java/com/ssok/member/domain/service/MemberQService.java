package com.ssok.member.domain.service;

import com.ssok.member.domain.entity.MemberDoc;
import com.ssok.member.domain.repository.mongo.MemberMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberQService {
    private final MemberMongoRepository memberMongoRepository;

    public void test1(){
        MemberDoc memberDoc = MemberDoc.builder().memberName("김나박이").build();
        memberMongoRepository.save(memberDoc);
    }

}
