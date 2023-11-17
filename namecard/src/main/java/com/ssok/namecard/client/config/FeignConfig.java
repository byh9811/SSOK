package com.ssok.namecard.client.config;

import feign.RequestInterceptor;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableFeignClients(basePackages = "com.ssok.namecard.client")
public class FeignConfig {

    @Bean
    public RequestInterceptor requestInterceptor(){
        return requestTemplate -> requestTemplate.header("Content-Type", "application/json");
    }

}
