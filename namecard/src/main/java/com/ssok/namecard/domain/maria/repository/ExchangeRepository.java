package com.ssok.namecard.domain.maria.repository;

import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ExchangeRepository extends JpaRepository<Exchange, Long> {

    @Query("SELECT e FROM Exchange e WHERE (e.sendNamecard = :namecardA AND e.receiveNamecard = :namecardB)")
    List<Exchange> findAllExchangesBetweenTwoNamecards(@Param("namecardA") Namecard namecardA, @Param("namecardB") Namecard namecardB);


    Optional<Exchange> findBySendNamecardNamecardSeqAndReceiveNamecardNamecardSeq(Long namecardSeq, Long targetNamecardSeq);

    Optional<Exchange> findByExchangeSeq(Long exchangeSeq);

}
