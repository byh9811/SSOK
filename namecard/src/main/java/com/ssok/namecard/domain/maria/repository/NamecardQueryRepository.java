package com.ssok.namecard.domain.maria.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class NamecardQueryRepository {

    private final JPAQueryFactory queryFactory;

}
