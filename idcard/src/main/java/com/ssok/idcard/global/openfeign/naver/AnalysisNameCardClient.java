package com.ssok.idcard.global.openfeign.naver;

import com.ssok.idcard.global.config.OpenFeignConfig;
import com.ssok.idcard.global.openfeign.naver.dto.response.NameCardOcrResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import java.util.Optional;

@FeignClient(name = "navernamecardOCR", url = "${ocr.namecard.url}",
        configuration = OpenFeignConfig.class)
public interface AnalysisNameCardClient {
    @PostMapping(value="", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    Optional<NameCardOcrResponse> analyzeNameCard(
            @RequestHeader("X-OCR-SECRET") String key,
            @RequestPart(value = "message") String message,
            @RequestPart(value = "file") MultipartFile file);

}
