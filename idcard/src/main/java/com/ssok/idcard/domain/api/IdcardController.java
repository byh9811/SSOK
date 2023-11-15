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
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import static com.ssok.idcard.global.api.ApiResponse.OK;
import static com.ssok.idcard.global.api.ApiResponse.ERROR;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/idcard-service")
@Slf4j
public class IdcardController {

    private final IdcardService idcardService;
    private final AnalysisService analysisService;
    private final MemberServiceClient memberServiceClient;

    @GetMapping("/license")
    public ApiResponse<LicenseGetResponse> getLicense(@RequestHeader("MEMBER-UUID") String memberUUID){
        log.info("license get method entered");

        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();
        LicenseGetDto licenseGetDto = idcardService.getLicense(memberSeq);
        if(licenseGetDto == null) return OK(null);
        return OK(licenseGetDto.of(licenseGetDto));
    }

    @PostMapping(path = "/license", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ApiResponse<?> createLicense(
            @RequestHeader("MEMBER-UUID") String memberUUID,
            @RequestPart LicenseCreateRequest licenseCreateRequest,
            @RequestPart(name = "image") MultipartFile multipartFile
    ) {
        log.info("entered createLicense");
        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();

        String validationError = licenseCreateRequest.validate();

        if(validationError != null){
            return ERROR(validationError, HttpStatus.BAD_REQUEST);
        }

        idcardService.createLicense(LicenseCreateDto.fromRequest(memberSeq, licenseCreateRequest), multipartFile);
        return OK(null);
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

    @PostMapping(path = "/registration", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ApiResponse<?> createRegistrationCard(
            @RequestHeader("MEMBER-UUID") String memberUUID,
            @RequestPart RegistrationCardCreateRequest request,
            @RequestPart(name = "image") MultipartFile multipartFile
            )
    {
        Long memberSeq = memberServiceClient.getMemberseq(memberUUID).getResponse();

        String validationError = request.validate();
        if(validationError != null){
            return ERROR(validationError, HttpStatus.BAD_REQUEST);
        }

        idcardService.createRegistrationCard(RegistrationCreateDto.fromRequest(memberSeq, request), multipartFile);
        return OK(null);
    }

    @PostMapping(path = "/scan/registration", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ApiResponse<?> ocrRegistration(
            @RequestPart(value="img") MultipartFile file
    ) {
        log.info("controller entered method ocrRegistration");
        RecognizedRegistrationCardResponse result = analysisService.analysisRegistration(file);
        if(result ==  null) return ERROR("주민등록증을 다시 촬영해주세요", HttpStatus.BAD_REQUEST);
        return OK(result);
    }

    @PostMapping(path = "/scan/license", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ApiResponse<?> ocrLicense(
            @RequestPart(value="img") MultipartFile file
    ) {
        log.info("controller entered method ocrLicense");
        RecognizedLicenseResponse result = analysisService.analysisLicense(file);
        if(result ==  null){
            return ERROR("운전면허증을 다시 촬영해주세요", HttpStatus.BAD_REQUEST);
        }
        return OK(result);
    }

    @PostMapping(path = "/scan/namecard", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ApiResponse<?> ocrNameCard(
            @RequestPart(value="img") MultipartFile file
    ) {
        log.info("controller entered method ocrNameCard");
        RecognizedNameCardResponse result = analysisService.analysisNameCard(file);
        if(result ==  null){
            return ERROR("명함을 다시 촬영해주세요", HttpStatus.BAD_REQUEST);
        }
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
