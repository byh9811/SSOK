package com.ssok.mydata.domain.pos.repository;

import com.ssok.mydata.domain.pos.entity.Item;
import com.ssok.mydata.domain.pos.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ItemRepository extends JpaRepository<Item, String> {

}
