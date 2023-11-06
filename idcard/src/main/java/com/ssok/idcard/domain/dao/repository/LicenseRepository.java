package com.ssok.idcard.domain.dao.repository;

import com.ssok.idcard.domain.dao.entity.License;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

public interface LicenseRepository extends JpaRepository<License, Long> {

    License findByMemberSeq(Long memberSeq);
}
