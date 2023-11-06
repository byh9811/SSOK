package com.ssok.idcard.domain.api;

import com.ssok.idcard.domain.api.request.LicenseCreateRequest;
import com.ssok.idcard.domain.api.request.RegistrationCardCreateRequest;
import com.ssok.idcard.domain.api.response.LicenseCreateResponse;
import com.ssok.idcard.domain.api.response.LicenseGetResponse;
import com.ssok.idcard.domain.api.response.RegistrationGetResponse;
import com.ssok.idcard.domain.dao.entity.RegistrationCard;
import com.ssok.idcard.domain.service.IdcardService;
import com.ssok.idcard.domain.service.MemberServiceClient;
import com.ssok.idcard.domain.service.dto.LicenseCreateDto;
import com.ssok.idcard.domain.service.dto.LicenseGetDto;
import com.ssok.idcard.domain.service.dto.RegistrationCreateDto;
import com.ssok.idcard.domain.service.dto.RegistrationGetDto;
import com.ssok.idcard.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

// @RequestHeader("MEMBER-UUID") String memberUUID
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/idcard-service")
@Slf4j
public class IdcardController {

    private final IdcardService idcardService;

    private final MemberServiceClient memberServiceClient;

    @PostMapping("/license")
    public ApiResponse<Void> createLicense(
            @RequestHeader("MEMBER-UUID") String memberUUID, @RequestBody LicenseCreateRequest licenseCreateRequest)
    {
        log.info("entered createLicense");
        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();
        idcardService.createLicense(LicenseCreateDto.fromRequest(memberSeq, licenseCreateRequest));
        return ApiResponse.OK(null);
    }

    @GetMapping("/license")
    public ApiResponse<LicenseGetResponse> getLicense(@RequestHeader("MEMBER-UUID") String memberUUID){
        log.info("license get method entered");

        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();
        LicenseGetDto licenseGetDto = idcardService.getLicense(memberSeq);
        LicenseGetResponse licenseGetResponse = licenseGetDto.of(licenseGetDto);

        return ApiResponse.OK(licenseGetResponse);
    }

    @GetMapping("/registration")
    public ApiResponse<RegistrationGetResponse> getRegistrationCard(
            @RequestHeader("MEMBER-UUID") String memberUUID
    ){
        log.info("entered controller registration get method");

        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();

        RegistrationGetDto registrationGetDto = idcardService.getRegistration(memberSeq);

        RegistrationGetResponse registrationGetResponse = registrationGetDto.of(registrationGetDto);

        return ApiResponse.OK(registrationGetResponse);
    }

    @PostMapping("/registration")
    public ApiResponse<Void> createRegistrationCard(
            @RequestHeader("MEMBER-UUID") String memberUUID, @RequestBody RegistrationCardCreateRequest request)
    {
        log.info("entered controller createRegistrationCard method");
        log.info("requestbody ->");
        log.info(request.toString());
        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();
        idcardService.createRegistrationCard(RegistrationCreateDto.fromRequest(memberSeq, request));

        return ApiResponse.OK(null);
    }
}
