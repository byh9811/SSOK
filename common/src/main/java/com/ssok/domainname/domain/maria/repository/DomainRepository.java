package com.ssok.domainname.domain.maria.repository;

import com.ssok.domainname.domain.maria.entity.Domain;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DomainRepository extends JpaRepository<Domain, Long> {

}
