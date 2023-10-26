package com.ssok.base.domainname.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class DomainQueryRepository {

    private final JPAQueryFactory queryFactory;

}
