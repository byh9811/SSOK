package com.ssok.idcard.domain.dao.repository;

import com.ssok.idcard.domain.dao.entity.RegistrationCard;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RegistrationCardRepository extends JpaRepository<RegistrationCard, Long> {
    RegistrationCard findByMemberSeq(Long memberSeq);
}
