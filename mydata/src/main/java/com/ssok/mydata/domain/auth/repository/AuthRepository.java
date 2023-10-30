package com.ssok.mydata.domain.auth.repository;

import com.ssok.mydata.domain.auth.entity.Auth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AuthRepository extends JpaRepository<Auth, Long> {

    boolean existsByUserCi(String userCi);

}
