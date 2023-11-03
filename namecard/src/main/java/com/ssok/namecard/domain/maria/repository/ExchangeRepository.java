package com.ssok.namecard.domain.maria.repository;

import com.ssok.namecard.domain.maria.entity.Exchange;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExchangeRepository extends JpaRepository<Exchange, Long> {

    Optional<Exchange> findByNamecardIdAndMemberId(Long namecardAId, Long memberBId);
}
