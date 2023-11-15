package com.ssok.member.domain.service.dto;

import com.ssok.member.domain.api.dto.request.MemberSimplePasswordCheckRequest;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberSimplePasswordCheckDto {
    private String loginId;
    private String simplePassword;

    public static MemberSimplePasswordCheckDto of(MemberSimplePasswordCheckRequest memberSimplePasswordCheckRequest){
        return MemberSimplePasswordCheckDto.builder()
                .loginId(memberSimplePasswordCheckRequest.getLoginId())
                .simplePassword(memberSimplePasswordCheckRequest.getSimplePassword())
                .build();
    }
}
