package com.ssok.base.domain.maria.repository;

import com.ssok.base.domain.maria.entity.ChangeHistory;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ChangeHistoryRepository extends JpaRepository<ChangeHistory, Long> {
}
