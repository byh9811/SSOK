package com.ssok.idcard.global.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.UUID;
import javax.annotation.PostConstruct;

import com.google.auth.Credentials;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import com.ssok.idcard.global.error.ErrorCode;
import com.ssok.idcard.global.error.NamecardException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@RequiredArgsConstructor
@Service
public class GCSUtil {

    @Value("${spring.cloud.gcp.storage.bucket}")
    private String bucketName;

    @Value("${spring.cloud.gcp.storage.credentials.encoded-key}")
    private String encodedKey;

    private Storage storage;

    @PostConstruct
    public void init() throws IOException {
        byte[] decodedKey = Base64.getDecoder().decode(encodedKey);
        Credentials credentials = GoogleCredentials.fromStream(new ByteArrayInputStream(decodedKey));
        storage = StorageOptions.newBuilder()
                                .setCredentials(credentials)
                                .build()
                                .getService();
    }

    public String uploadFile(MultipartFile multipartFile) {

        // 고유한 파일 이름 생성
        String uuid = UUID.randomUUID().toString();
        // 파일의 원래 이름 가져오기
        String originalFilename = multipartFile.getOriginalFilename();
        // 파일 확장자 추출
        String ext = originalFilename.substring(originalFilename.lastIndexOf("."));

        // 저장될 파일 이름 (UUID + 확장자)
        String fileName = uuid + ext;

        // BlobId 생성
        BlobId blobId = BlobId.of(bucketName, fileName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType(multipartFile.getContentType()).build();

        // 파일 내용으로 Blob 생성
        try {
            storage.create(blobInfo, multipartFile.getBytes());
        } catch (IOException e) {
            throw new NamecardException(ErrorCode.GCS_EXCEPTION);
        }

        String filePath = "https://storage.googleapis.com/" + bucketName + "/" + fileName;
        log.info("File uploaded to: " + filePath);
        return filePath;

    }

    public boolean deleteFile(String filePath) {
        //이미지 주소 현재 prefix 붙어 있음
        String[] parts = filePath.replace("https://storage.googleapis.com/", "").split("/", 2);
        String bucketName = parts[0];
        String objectName = parts[1];
        log.info("버킷이름: {}", bucketName);
        log.info("객체이름: {}", objectName);

        // BlobId를 사용하여 파일 삭제를 요청합니다.
        BlobId blobId = BlobId.of(bucketName, objectName);
        boolean deleted = storage.delete(blobId);

        if (deleted) {
            log.info("File deleted: " + filePath);
        } else {
            log.info("File not found: " + filePath);
        }
        return deleted;
    }
}
