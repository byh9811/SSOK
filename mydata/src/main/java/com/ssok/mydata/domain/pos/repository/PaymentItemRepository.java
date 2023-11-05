package com.ssok.mydata.domain.pos.repository;

import com.ssok.mydata.domain.pos.entity.Payment;
import com.ssok.mydata.domain.pos.entity.PaymentItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentItemRepository extends JpaRepository<PaymentItem, Long> {

}
