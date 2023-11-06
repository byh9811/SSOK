package com.ssok.receipt.domain.maria.repository;

import com.ssok.receipt.domain.maria.entity.PurchaseItem;
import com.ssok.receipt.domain.maria.entity.Receipt;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PurchaseItemRepository extends JpaRepository<PurchaseItem, Long> {

}
