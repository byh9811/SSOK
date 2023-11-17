package com.ssok.base.domain.maria.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class PocketQueryRepository {

    private final JPAQueryFactory queryFactory;

}
