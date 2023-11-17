package com.ssok.receipt.domain.maria.entity;

import com.ssok.receipt.global.entity.BaseEntity;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
public class EcoItem extends BaseEntity {

    @Id
    private String ecoItemNumber;

    private String ecoItemCompany;

    private String ecoItemName;

    private Long ecoItemPoint;

    private String authDivision;

}
