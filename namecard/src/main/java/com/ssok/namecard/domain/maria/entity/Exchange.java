package com.ssok.namecard.domain.maria.entity;

import com.ssok.namecard.global.entity.BaseEntity;
import javax.persistence.Entity;
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

    private String memberId;
    private String namecardId;
    private String exchangeLatitude;
    private String exchangeLongitude;
    private String exchangeNote;
    private String exchangeFavorite;
}
