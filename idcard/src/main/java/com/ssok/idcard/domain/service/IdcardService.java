package com.ssok.idcard.domain.service;

import com.ssok.idcard.domain.api.response.LicenseGetResponse;
import com.ssok.idcard.domain.dao.entity.License;
import com.ssok.idcard.domain.dao.entity.RegistrationCard;
import com.ssok.idcard.domain.dao.repository.LicenseRepository;
import com.ssok.idcard.domain.dao.repository.RegistrationCardRepository;
import com.ssok.idcard.domain.service.dto.LicenseCreateDto;
import com.ssok.idcard.domain.service.dto.LicenseGetDto;
import com.ssok.idcard.domain.service.dto.RegistrationCreateDto;
import com.ssok.idcard.domain.service.dto.RegistrationGetDto;
import com.ssok.idcard.global.util.GCSUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class IdcardService {

    private final LicenseRepository licenseRepository;
    private final RegistrationCardRepository registrationCardRepository;
    private final GCSUtil gcsUtil;

    public void createLicense(LicenseCreateDto licenseCreateDto, MultipartFile multipartFile) {
        String uploadUrl = gcsUtil.uploadFile(multipartFile);

        License license = License.builder().
                memberSeq(licenseCreateDto.memberSeq()).
                licenseName(licenseCreateDto.licenseName()).
                licensePersonalNumber(licenseCreateDto.licensePersonalNumber()).
                licenseType(licenseCreateDto.licenseType()).
                licenseAddress(licenseCreateDto.licenseAddress()).
                licenseNumber(licenseCreateDto.licenseNumber()).
                licenseRenewStartDate(licenseCreateDto.licenseRenewStartDate()).
                licenseRenewEndDate(licenseCreateDto.licenseRenewEndDate()).
                licenseCondition(licenseCreateDto.licenseCondition()).
                licenseCode(licenseCreateDto.licenseCode()).
                licenseIssueDate(licenseCreateDto.licenseIssueDate()).
                licenseAuthority(licenseCreateDto.licenseAuthority()).
                licenseImage(uploadUrl).
                build();

        licenseRepository.save(license);
    }

    public LicenseGetDto getLicense(Long memberSeq) {
        log.info("service getLicense method entered");

        License license = licenseRepository.findByMemberSeq(memberSeq);

        log.info("license value =======");
        log.info(license.toString());
        LicenseGetDto licenseGetDto = license.of(license);
        log.info(licenseGetDto.toString());

        return licenseGetDto;
    }

    public RegistrationGetDto getRegistration(Long memberSeq) {
        log.info("entered service getRegistration method");

        RegistrationCard registrationCard = registrationCardRepository.findByMemberSeq(memberSeq);

        RegistrationGetDto registrationGetDto = registrationCard.of(registrationCard);
        log.info(registrationGetDto.toString());
        return registrationGetDto;
    }

    public void createRegistrationCard(RegistrationCreateDto registrationCreateDto, MultipartFile multipartFile) {
        String uploadUrl = gcsUtil.uploadFile(multipartFile);

        RegistrationCard registrationCard = RegistrationCard.builder().
                memberSeq(registrationCreateDto.memberSeq()).
                registrationCardName(registrationCreateDto.registrationCardName()).
                registrationCardAddress(registrationCreateDto.registrationCardAddress()).
                registrationCardPersonalNumber(registrationCreateDto.registrationCardPersonalNumber()).
                registrationCardIssueDate(registrationCreateDto.registrationCardIssueDate()).
                registrationCardAuthority(registrationCreateDto.registrationCardAuthority()).
                registrationCardImage(uploadUrl).
                build();

        registrationCardRepository.save(registrationCard);
    }

}
