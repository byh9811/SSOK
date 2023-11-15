package com.ssok.member.domain.api.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemberSimplePasswordCheckRequest {
    private String loginId;
    private String simplePassword;
}
