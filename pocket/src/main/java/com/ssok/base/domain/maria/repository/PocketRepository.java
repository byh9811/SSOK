package com.ssok.base.domain.maria.repository;

import com.ssok.base.domain.maria.entity.Domain;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PocketRepository extends JpaRepository<Domain, Long> {

}
