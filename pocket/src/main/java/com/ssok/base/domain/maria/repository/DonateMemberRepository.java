package com.ssok.base.domain.maria.repository;

import com.ssok.base.domain.maria.entity.Donate;
import com.ssok.base.domain.maria.entity.DonateMember;
import com.ssok.base.domain.maria.entity.DonateMemberKey;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface DonateMemberRepository extends JpaRepository<DonateMember, Long> {
    Optional<DonateMember> findByDonateAndMemberSeq(Donate donate, Long memberSeq);
}
