package com.ssok.idcard.global.util;

import org.springframework.stereotype.Component;

@Component
public class FileUtil {

    public String extractExt(String originalFilename) {
        int pos = originalFilename.lastIndexOf(".");
        return originalFilename.substring(pos + 1);

    }
}
