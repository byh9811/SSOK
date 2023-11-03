package com.ssok.mydata.domain.auth.repository;

import com.ssok.mydata.domain.auth.entity.Auth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AuthRepository extends JpaRepository<Auth, Long> {

    boolean existsByMemberCi(String userCi);

    boolean existsByMemberCiAndRegisteredAccount(String userCi, boolean registeredAccount);

    Optional<Auth> findByMemberCi(String memberCi);

}
