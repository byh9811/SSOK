package com.ssok.namecard.domain.maria.repository;


import com.ssok.namecard.domain.maria.entity.Namecard;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface NamecardRepository extends JpaRepository<Namecard, Long> {
    Optional<Namecard> findByNamecardSeq(Long seq);

    List<Namecard> findAllByMemberSeqOrderByCreateDateDesc(Long memberSeq);

    Optional<Namecard> findByMemberSeq(Long memberSeq);

    @Query("SELECT n.namecardImage FROM Namecard n WHERE n.memberSeq = :memberSeq ORDER BY n.createDate DESC")
    List<String> findAllNamecardImage(@Param("memberSeq") Long memberSeq);

    List<Namecard> findAllByMemberSeq(Long memberSeq);
}
