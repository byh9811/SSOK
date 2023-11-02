package com.ssok.member.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class memberController {
    @GetMapping("/service")
    public String springCloudService() {
        return "spring-cloud-service 호출!";
    }
}
