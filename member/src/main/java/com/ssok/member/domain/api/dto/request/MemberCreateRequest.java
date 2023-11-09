package com.ssok.member.domain.api.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberCreateRequest {
    private String loginId;
    private String password; //비밀번호
    private String name;//이름
    private String phone; //전화번호
    private String simplePassword;
}

