package com.ssok.idcard.domain.api;

import com.ssok.idcard.domain.api.request.LicenseCreateRequest;
import com.ssok.idcard.domain.api.request.RegistrationCardCreateRequest;
import com.ssok.idcard.domain.api.response.*;
import com.ssok.idcard.domain.service.AnalysisService;
import com.ssok.idcard.domain.service.IdcardService;
import com.ssok.idcard.domain.service.MemberServiceClient;
import com.ssok.idcard.domain.service.dto.LicenseCreateDto;
import com.ssok.idcard.domain.service.dto.LicenseGetDto;
import com.ssok.idcard.domain.service.dto.RegistrationCreateDto;
import com.ssok.idcard.domain.service.dto.RegistrationGetDto;
import com.ssok.idcard.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import static com.ssok.idcard.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/idcard-service")
@Slf4j
public class IdcardController {

    private final IdcardService idcardService;
    private final AnalysisService analysisService;
    private final MemberServiceClient memberServiceClient;

    @PostMapping("/license")
    public ApiResponse<Void> createLicense(
            @RequestHeader("MEMBER-UUID") String memberUUID,
            @RequestPart LicenseCreateRequest licenseCreateRequest,
            @RequestPart(name = "image") MultipartFile multipartFile
    ) {
        log.info("entered createLicense");
        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();
        idcardService.createLicense(LicenseCreateDto.fromRequest(memberSeq, licenseCreateRequest), multipartFile);
        return OK(null);
    }

    @GetMapping("/license")
    public ApiResponse<LicenseGetResponse> getLicense(@RequestHeader("MEMBER-UUID") String memberUUID){
        log.info("license get method entered");

        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();
        LicenseGetDto licenseGetDto = idcardService.getLicense(memberSeq);
        if(licenseGetDto == null) return OK(null);
        return OK(licenseGetDto.of(licenseGetDto));
    }

    @GetMapping("/registration")
    public ApiResponse<RegistrationGetResponse> getRegistrationCard(
            @RequestHeader("MEMBER-UUID") String memberUUID
    ){
        log.info("entered controller registration get method");

        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();

        RegistrationGetDto registrationGetDto = idcardService.getRegistration(memberSeq);

        if(registrationGetDto == null) return OK(null);
        else return OK(registrationGetDto.of(registrationGetDto));
    }

    @PostMapping("/registration")
    public ApiResponse<Void> createRegistrationCard(
            @RequestHeader("MEMBER-UUID") String memberUUID,
            @RequestPart RegistrationCardCreateRequest request,
            @RequestPart(name = "image") MultipartFile multipartFile
            )
    {
        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();
        idcardService.createRegistrationCard(RegistrationCreateDto.fromRequest(memberSeq, request), multipartFile);

        return OK(null);
    }

    @PostMapping("/scan/registration")
    public ApiResponse<RecognizedRegistrationCardResponse> ocrRegistration(
            @RequestPart(value="img") MultipartFile file
    ) {
        RecognizedRegistrationCardResponse result = analysisService.analysisRegistration(file);
        return OK(result);
    }

    @PostMapping("/scan/license")
    public ApiResponse<RecognizedLicenseResponse> ocrLicense(
            @RequestPart(value="img") MultipartFile file
    ) {
        RecognizedLicenseResponse result = analysisService.analysisLicense(file);
        return OK(result);
    }

    @PostMapping("/scan/namecard")
    public ApiResponse<RecognizedNameCardResponse> ocrNameCard(
            @RequestPart(value="img") MultipartFile file
    ) {
        RecognizedNameCardResponse result = analysisService.analysisNameCard(file);
        return OK(result);
    }

    @GetMapping("/summary/idcard")
    public ApiResponse<SummaryIdcardGetResponse> getSummaryIdcard(
            @RequestHeader("MEMBER-UUID") String memberUUID
    ){

        log.debug("controller entered method getSummaryIdcard");
        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();
        SummaryIdcardGetResponse summaryIdcardGetResponse = idcardService.getSummaryIdcard(memberSeq);

        return OK(summaryIdcardGetResponse);
    }

}
