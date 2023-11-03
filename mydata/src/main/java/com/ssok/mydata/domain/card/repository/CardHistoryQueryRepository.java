package com.ssok.mydata.domain.card.repository;

import com.querydsl.core.types.Order;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssok.mydata.domain.card.api.dto.inner.CardTransactionList;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.ssok.mydata.domain.card.entity.QCardHistory.cardHistory;

@Repository
@RequiredArgsConstructor
public class CardHistoryQueryRepository {

    private final JPAQueryFactory queryFactory;

    public List<CardTransactionList> findCardTransactionList(String cardId, Long cursor, int limit) {
        return queryFactory.select(Projections.constructor(CardTransactionList.class,
                        cardHistory.id.as("history_id"),
                        cardHistory.approvedNum.as("approved_num"),
                        cardHistory.approvedDtime.as("approved_dtime"),
                        cardHistory.status.as("status"),
                        cardHistory.payType.as("pay_type"),
                        cardHistory.transDtime.as("trans_dtime"),
                        cardHistory.merchantName.as("merchant_name"),
                        cardHistory.merchantRegno.as("merchant_regno"),
                        cardHistory.approvedAmt.as("approved_amt"),
                        cardHistory.modifiedAmt.as("modified_amt"),
                        cardHistory.totalInstallCnt.as("total_install_cnt")
        ))
                .from(cardHistory)
                .where(
                        cardHistory.card.cardId.eq(cardId).and(ltCursor(cursor))
                )
                .orderBy(new OrderSpecifier<>(Order.DESC, cardHistory.id))
                .limit(limit + 1)
                .fetch();
    }

    public Long count() {
        return queryFactory.select(cardHistory.count())
                .from(cardHistory)
                .fetchFirst();
    }

    private BooleanExpression ltCursor(Long cursorId){
        return cursorId == null ? null : cardHistory.id.loe(cursorId);
    }

}
