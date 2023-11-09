package com.ssok.idcard.domain.service;

import com.ssok.idcard.domain.api.response.RecognizedLicenseResponse;
import com.ssok.idcard.domain.api.response.RecognizedNameCardResponse;
import com.ssok.idcard.domain.api.response.RecognizedRegistrationCardResponse;
import com.ssok.idcard.global.openfeign.naver.AnalysisClient;
import com.ssok.idcard.global.openfeign.naver.dto.response.NameCardOcrResponse;
import com.ssok.idcard.global.openfeign.naver.dto.response.RegistrationCardOcrResponse;
import com.ssok.idcard.global.openfeign.naver.dto.response.LicenseOcrResponse;
import com.ssok.idcard.global.util.FileUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class AnalysisService {

    @Value("${ocr.key}")
    private String ocrKey;
    private final AnalysisClient analysisClient;
    private final FileUtil fileUtil;

    public RecognizedLicenseResponse analysisLicense(MultipartFile file) {
        LicenseOcrResponse ocrDto = licenseOCR(file);
        return RecognizedLicenseResponse.from(ocrDto.getImages().get(0).getIdCard().getResult().getDl());
    }

    public RecognizedRegistrationCardResponse analysisRegistration(MultipartFile file) {
        RegistrationCardOcrResponse ocrDto = registrationCardOCR(file);
        return RecognizedRegistrationCardResponse.from(ocrDto.getImages().get(0).getIdCard().getResult().getIc());
    }

    public RecognizedNameCardResponse analysisNameCard(MultipartFile file) {
        NameCardOcrResponse ocrDto = nameCardOCR(file);
        return RecognizedNameCardResponse.from(ocrDto.getImages().get(0).getNameCard().getResult());
    }

    private String getMessage(MultipartFile file) {
        if (file.isEmpty()) {
            throw new RuntimeException("파일이 없습니다.");
        }

        return "{\"version\": \"V2\",\"requestId\": \"" + UUID.randomUUID() +
                "\",\"timestamp\": " + System.currentTimeMillis() +
                ",\"images\": [{ \"format\": \"" + fileUtil.extractExt(file.getOriginalFilename()) +
                // images.data가 있어야 될거 같은데 ?
                "\", \"name\": \"" + file.getOriginalFilename() +
                "\" }]}";
    }

    private LicenseOcrResponse licenseOCR(MultipartFile file) {
        String message = getMessage(file);
        return analysisClient.analyzeLicense(ocrKey, message, file).get();
    }

    private RegistrationCardOcrResponse registrationCardOCR(MultipartFile file) {
        String message = getMessage(file);
        return analysisClient.analyzeIdcard(ocrKey, message, file).get();
    }
    private NameCardOcrResponse nameCardOCR(MultipartFile file) {
        String message = getMessage(file);
        return analysisClient.analyzeNameCard(ocrKey, message, file).get();
    }

}
