package com.ssok.receipt.domain.maria.repository;

import com.ssok.receipt.domain.maria.entity.CardCompany;
import com.ssok.receipt.domain.maria.entity.EcoItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EcoItemRepository extends JpaRepository<EcoItem, String> {

}
