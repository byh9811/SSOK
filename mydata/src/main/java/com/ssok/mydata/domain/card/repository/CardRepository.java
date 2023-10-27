package com.ssok.mydata.domain.card.repository;

import com.ssok.mydata.domain.card.entity.Card;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CardRepository extends JpaRepository<Card, Long> {

    boolean existsByMemberCi(Long memberCi);

}
