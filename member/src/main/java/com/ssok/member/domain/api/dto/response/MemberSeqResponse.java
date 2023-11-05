package com.ssok.member.domain.api.dto.response;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
public class MemberSeqResponse {
    private String UUID;
    private Long memberSeq;
}