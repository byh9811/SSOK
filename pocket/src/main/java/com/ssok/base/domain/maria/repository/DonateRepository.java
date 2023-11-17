package com.ssok.base.domain.maria.repository;

import com.ssok.base.domain.maria.entity.Donate;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DonateRepository extends JpaRepository<Donate, Long> {
}
