package com.ssok.idcard.domain.dao.entity;

import com.ssok.idcard.domain.service.dto.LicenseGetDto;
import com.ssok.idcard.global.entity.BaseEntity;
import lombok.*;
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
@ToString
public class License extends BaseEntity implements Serializable {

    @Id
    private Long memberSeq;

    @Column(nullable = false)
    @Size(max = 30)
    private String licenseName;

    @Column(nullable = false)
    @Size(max = 14)
    private String licensePersonalNumber;

    @Column(nullable = false)
    @Size(max = 50)
    private String licenseType;

    @Column(nullable = false)
    @Size(max = 200)
    private String licenseAddress;

    @Column(nullable = false)
    @Size(max = 15)
    private String licenseNumber;

    @Column(nullable = false)
    private LocalDate licenseRenewStartDate;

    @Column(nullable = false)
    private LocalDate licenseRenewEndDate;

    @Column(nullable = true)
    @Size(max = 30)
    private String licenseCondition;

    @Column(nullable = false)
    private String licenseCode;

    @Column(nullable = false)
    private LocalDate licenseIssueDate;

    @Column(nullable = false)
    @Size(max = 15)
    private String licenseAuthority;

    @Column(nullable = false)
    @Size(max = 1024)
    private String licenseImage;


    public LicenseGetDto of(License license) {
        return new LicenseGetDto(
                license.licenseName,
                license.licensePersonalNumber,
                license.licenseType,
                license.licenseAddress,
                license.licenseNumber,
                license.licenseRenewStartDate,
                license.licenseRenewEndDate,
                license.licenseCondition,
                license.licenseCode,
                license.licenseIssueDate,
                license.licenseAuthority,
                license.licenseImage
        );
    }
}
