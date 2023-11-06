package com.ssok.base.domain.maria.repository;

import com.ssok.base.domain.maria.entity.CarbonHistory;
import com.ssok.base.domain.maria.entity.CarbonHistoryKey;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CarbonHistoryRepository extends JpaRepository<CarbonHistory, Long> {
}
