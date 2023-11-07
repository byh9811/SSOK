package com.ssok.receipt.domain.maria.repository;

import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.entity.PurchaseItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CardRepository extends JpaRepository<Card, Long> {

    Optional<Card> findByMemberSeq(Long memberSeq);

    Optional<Card> findByCardNum(String cardNum);
}
