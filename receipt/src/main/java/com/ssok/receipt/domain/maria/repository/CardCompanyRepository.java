package com.ssok.receipt.domain.maria.repository;

import com.ssok.receipt.domain.maria.entity.Card;
import com.ssok.receipt.domain.maria.entity.CardCompany;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CardCompanyRepository extends JpaRepository<CardCompany, Integer> {

}
