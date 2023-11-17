package com.ssok.member.domain.service.dto;

import com.ssok.member.domain.api.dto.request.MemberLoginRequest;
import lombok.*;
import org.springframework.stereotype.Service;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberLoginDto {
    private String loginId;
    private String password;

    public static MemberLoginDto of(MemberLoginRequest memberLoginRequest){
        return MemberLoginDto.builder()
                .loginId(memberLoginRequest.getLoginId())
                .password(memberLoginRequest.getPassword())
                .build();
    }
}
