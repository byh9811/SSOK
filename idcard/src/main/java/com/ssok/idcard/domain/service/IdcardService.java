package com.ssok.idcard.domain.service;

import com.ssok.idcard.domain.api.response.LicenseGetResponse;
import com.ssok.idcard.domain.api.response.SummaryIdcardGetResponse;
import com.ssok.idcard.domain.dao.entity.License;
import com.ssok.idcard.domain.dao.entity.RegistrationCard;
import com.ssok.idcard.domain.dao.repository.LicenseRepository;
import com.ssok.idcard.domain.dao.repository.RegistrationCardRepository;
import com.ssok.idcard.domain.service.dto.*;
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
@Transactional
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

        if(license == null) return null;

        return license.of(license);
    }

    public RegistrationGetDto getRegistration(Long memberSeq) {
        log.info("entered service getRegistration method");

        RegistrationCard registrationCard = registrationCardRepository.findByMemberSeq(memberSeq);
        log.info("registrationCard.toString:");

        if(registrationCard == null) return null;
        else return registrationCard.of(registrationCard);
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

    public SummaryIdcardGetResponse getSummaryIdcard(Long memberSeq) {
        RegistrationCard registrationCard = registrationCardRepository.findByMemberSeq(memberSeq);
        License license = licenseRepository.findByMemberSeq(memberSeq);

        SummaryRegistrationCardDto summaryRegistrationCardDto = SummaryRegistrationCardDto.from(registrationCard);
        SummaryLicenseDto summaryLicenseDto = SummaryLicenseDto.from(license);

        return new SummaryIdcardGetResponse(summaryRegistrationCardDto, summaryLicenseDto);
    }

    public void deleteRegistrationCard(Long memberSeq) {
        log.info("entered service method deleteRegistrationCard(Long memberSeq), memberSeq --> ");
        log.info(String.valueOf(memberSeq));

        registrationCardRepository.deleteByMemberSeq(memberSeq);
    }

    public void deleteLicenseCard(Long memberSeq) {
        log.info("entered Service method deleteLicense(Long memberSeq), member Seq --> ");
        log.info(String.valueOf(memberSeq));

        licenseRepository.deleteByMemberSeq(memberSeq);
    }
}
