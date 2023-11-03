package com.ssok.mydata.domain.card.repository;

import com.ssok.mydata.domain.card.entity.Card;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CardRepository extends JpaRepository<Card, String> {

    boolean existsByMemberCi(String memberCi);

    Optional<Card> findByCardId(String cardId);

}
