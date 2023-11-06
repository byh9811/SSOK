package com.ssok.idcard.global.config;

import feign.RequestInterceptor;
import org.springframework.context.annotation.Bean;

public class OpenFeignConfig {

    @Bean
    public RequestInterceptor requestInterceptor() {
        return requestTemplate -> {
            requestTemplate.header("Content-Type", "application/json");
            requestTemplate.header("Accept", "application/json");
        };
    }

}