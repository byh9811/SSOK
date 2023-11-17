package com.ssok.member.domain.api.dto.request;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MemberSeqRequest {
    private String memberUuid;
}
