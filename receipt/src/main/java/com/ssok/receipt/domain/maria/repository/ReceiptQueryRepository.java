package com.ssok.receipt.domain.maria.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class ReceiptQueryRepository {

    private final JPAQueryFactory queryFactory;

}
