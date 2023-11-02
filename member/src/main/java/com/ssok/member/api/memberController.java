package com.ssok.member.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/member-service")
public class memberController {
    @GetMapping("/service")
    public String springCloudService() {
        System.out.println("test");
        return "spring-cloud-service 호출!";
    }
}
