package com.ssok.idcard.domain.service;

import com.ssok.idcard.domain.api.response.RecognizedLicenseResponse;
import com.ssok.idcard.domain.api.response.RecognizedNameCardResponse;
import com.ssok.idcard.domain.api.response.RecognizedRegistrationCardResponse;
import com.ssok.idcard.global.openfeign.naver.AnalysisIdcardClient;
import com.ssok.idcard.global.openfeign.naver.AnalysisNameCardClient;
import com.ssok.idcard.global.openfeign.naver.dto.response.NameCardOcrResponse;
import com.ssok.idcard.global.openfeign.naver.dto.response.RegistrationCardOcrResponse;
import com.ssok.idcard.global.openfeign.naver.dto.response.LicenseOcrResponse;
import com.ssok.idcard.global.util.FileUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class AnalysisService {

    @Value("${ocr.idcard.key}")
    private String ocrIdcardKey;

    @Value("${ocr.namecard.key}")
    private String ocrnameCardKey;

    private final AnalysisIdcardClient analysisIdcardClient;
    private final AnalysisNameCardClient analysisNameCardClient;
    private final FileUtil fileUtil;

    public RecognizedLicenseResponse analysisLicense(MultipartFile file) {
        log.info("service entered method analysisLicense");
        LicenseOcrResponse ocrDto = licenseOCR(file);

        if(ocrDto.getImages() == null) return null;

        log.info("ocrDto =============");
        log.info(ocrDto.toString());
        return RecognizedLicenseResponse.from(ocrDto.getImages().get(0).getIdCard().getResult().getDl());
    }

    public RecognizedRegistrationCardResponse analysisRegistration(MultipartFile file) {
        log.info("service entered method analysisLRegistration");
        RegistrationCardOcrResponse ocrDto = registrationCardOCR(file);

        if(ocrDto.getImages() == null) return null;
        log.info("ocrDto =============");
        log.info(ocrDto.toString());
        return RecognizedRegistrationCardResponse.from(ocrDto.getImages().get(0).getIdCard().getResult().getIc());
    }

    public RecognizedNameCardResponse analysisNameCard(MultipartFile file) {
        log.info("service entered method analysisNameCard");
        NameCardOcrResponse ocrDto = nameCardOCR(file);

        if(ocrDto.getImages() == null) return null;
        return RecognizedNameCardResponse.from(ocrDto.getImages().get(0).getNameCard().getResult());
    }

    private String getMessage(MultipartFile file) {
        if (file.isEmpty()) {
            throw new RuntimeException("파일이 없습니다.");
        }

        return "{\"version\": \"V2\",\"requestId\": \"" + UUID.randomUUID() +
                "\",\"timestamp\": " + System.currentTimeMillis() + ", \"lang\":\"ko\" " +
                ",\"images\": [{ \"format\": \"" + fileUtil.extractExt(file.getOriginalFilename()) +
                // images.data가 있어야 될거 같은데 ?
                "\", \"name\": \"" + file.getOriginalFilename() +
                "\" }]}";
    }

    private LicenseOcrResponse licenseOCR(MultipartFile file) {
        log.info("service licenseOCR method");
        String message = getMessage(file);
        log.info("message ================");
        log.info(message);
        log.info("ocrKey ==================");
        log.info(ocrIdcardKey);
        log.info("file ==================");
        log.info(file.toString());

        return analysisIdcardClient.analyzeLicense(ocrIdcardKey, message, file).get();
    }

    private RegistrationCardOcrResponse registrationCardOCR(MultipartFile file) {
        String message = getMessage(file);
        return analysisIdcardClient.analyzeIdcard(ocrIdcardKey, message, file).get();
    }
    private NameCardOcrResponse nameCardOCR(MultipartFile file) {

        String message = getMessage(file);
        log.info("message ================");
        log.info(message);
        log.info("ocrKey ==================");
        log.info(ocrnameCardKey);
        log.info("file ==================");
        log.info(file.toString());

        NameCardOcrResponse value = analysisNameCardClient.analyzeNameCard(ocrnameCardKey, message, file).get();

        log.info("value =============");
        log.info(value.toString());

        return value;
    }

}
