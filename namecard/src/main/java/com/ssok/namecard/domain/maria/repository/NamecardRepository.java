package com.ssok.namecard.domain.maria.repository;


import com.ssok.namecard.domain.maria.entity.Namecard;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NamecardRepository extends JpaRepository<Namecard, Long> {
    Optional<Namecard> findByNamecardSeq(Long seq);

}
