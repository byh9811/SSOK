package com.ssok.mydata.domain.card.repository;

import com.ssok.mydata.domain.card.entity.CardHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CardHistoryRepository extends JpaRepository<CardHistory, Long> {
    
}
