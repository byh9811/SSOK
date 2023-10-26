package com.ssok.base.domainname.repository;

import com.ssok.base.domainname.entity.Domain;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DomainRepository extends JpaRepository<Domain, Long> {

}
