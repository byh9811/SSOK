package com.ssok.receipt.domain.maria.entity;

import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
import com.ssok.receipt.global.entity.BaseEntity;
import com.ssok.receipt.global.enumerate.CardType;
import com.ssok.receipt.global.enumerate.TransactionType;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
public class CardCompany extends BaseEntity {

    @Id
    private Integer cardCompanyCode;

    private String cardCompanyName;

}
