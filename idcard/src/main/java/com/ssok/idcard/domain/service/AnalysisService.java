package com.ssok.idcard.domain.service;

import com.ssok.idcard.domain.api.response.RecognizedRegistrationCardResponse;
import com.ssok.idcard.global.openfeign.naver.AnalysisClient;
import com.ssok.idcard.global.openfeign.naver.dto.response.LicenseOcrResponse;
import com.ssok.idcard.global.util.FileUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class AnalysisService {

    @Value("${ocr.key}")
    private String ocrKey;
    private final AnalysisClient analysisClient;
    private final FileUtil fileUtil;

    public RecognizedRegistrationCardResponse analysis(MultipartFile file) {
        LicenseOcrResponse ocrDto = doOCR(file);
        return RecognizedRegistrationCardResponse.from(ocrDto.getImages().get(0).getIdCard().getResult().getDl());
    }

    private String getMessage(MultipartFile file) {
        if (file.isEmpty()) {
            throw new RuntimeException("파일이 없습니다.");
        }

        return "{\"version\": \"V2\",\"requestId\": \"" + UUID.randomUUID() +
                "\",\"timestamp\": " + System.currentTimeMillis() +
                ",\"images\": [{ \"format\": \"" + fileUtil.extractExt(file.getOriginalFilename()) +
                "\", \"name\": \"" + file.getOriginalFilename() +
                "\" }]}";
    }

    private LicenseOcrResponse doOCR(MultipartFile file) {
        String message = getMessage(file);
        return analysisClient.analyzeIdcard(ocrKey, message, file).get();
    }

}
