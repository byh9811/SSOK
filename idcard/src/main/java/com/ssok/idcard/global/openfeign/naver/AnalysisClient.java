package com.ssok.idcard.global.openfeign.naver;

import com.ssok.idcard.global.config.OpenFeignConfig;
import com.ssok.idcard.global.openfeign.naver.dto.response.NameCardOcrResponse;
import com.ssok.idcard.global.openfeign.naver.dto.response.RegistrationCardOcrResponse;
import com.ssok.idcard.global.openfeign.naver.dto.response.LicenseOcrResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;

@FeignClient(name = "naverOCR", url = "${ocr.url}",
        configuration = OpenFeignConfig.class)
public interface AnalysisClient {

    @PostMapping(value="", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    Optional<LicenseOcrResponse> analyzeLicense(
            @RequestHeader("X-OCR-SECRET") String key,
            @RequestPart(value = "message") String message,
            @RequestPart(value = "file") MultipartFile file);

    @PostMapping(value="", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    Optional<RegistrationCardOcrResponse> analyzeIdcard(
            @RequestHeader("X-OCR-SECRET") String key,
            @RequestPart(value = "message") String message,
            @RequestPart(value = "file") MultipartFile file);

    @PostMapping(value="", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    Optional<NameCardOcrResponse> analyzeNameCard(
            @RequestHeader("X-OCR-SECRET") String key,
            @RequestPart(value = "message") String message,
            @RequestPart(value = "file") MultipartFile file);

}
