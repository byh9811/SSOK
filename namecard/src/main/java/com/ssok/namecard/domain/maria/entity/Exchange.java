package com.ssok.namecard.domain.maria.entity;

import com.ssok.namecard.global.entity.BaseEntity;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
public class Exchange extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long exchangeSeq;

    private Long memberSeq;

    @ManyToOne
    @JoinColumn(name = "namecard_seq")
    private Namecard namecard;

    private Double exchangeLatitude;
    private Double exchangeLongitude;
    private String exchangeNote;
    private Boolean exchangeIsFavorite;
}
