package com.ssok.base.domain.maria.repository;

import com.ssok.base.domain.maria.entity.DonateMember;
import com.ssok.base.domain.maria.entity.DonateMemberKey;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DonateMemberRepository extends JpaRepository<DonateMember, DonateMemberKey> {
}
