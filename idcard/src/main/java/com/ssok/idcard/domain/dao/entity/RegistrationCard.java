package com.ssok.idcard.domain.dao.entity;

import com.ssok.idcard.domain.service.dto.RegistrationGetDto;
import com.ssok.idcard.global.entity.BaseEntity;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
public class RegistrationCard extends BaseEntity implements Serializable {

    @Id
    private Long memberSeq;

    @Column(nullable = false)
    @Size(max = 30)
    private String registrationCardName;

    @Column(nullable = false)
    @Size(max = 14)
    private String registrationCardPersonalNumber;

    @Column(nullable = false)
    @Size(max = 200)
    private String registrationCardAddress;

    @Column(nullable = false)
    private LocalDate registrationCardIssueDate;

    @Column(nullable = false)
    @Size(max = 15)
    private String registrationCardAuthority;

    @Column(nullable = true)
    @Size(max = 1024)
    private String registrationCardImage;

    public RegistrationGetDto of(RegistrationCard registrationCard) {

        if(registrationCard == null) return null;

        return new RegistrationGetDto(
                registrationCard.registrationCardName,
                registrationCard.registrationCardPersonalNumber,
                registrationCard.registrationCardAddress,
                registrationCard.registrationCardIssueDate,
                registrationCard.registrationCardAuthority,
                registrationCard.registrationCardImage
        );
    }
}
