package com.ssok.mydata.domain.pos.repository;

import com.ssok.mydata.domain.card.entity.Card;
import com.ssok.mydata.domain.pos.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, String> {

}
