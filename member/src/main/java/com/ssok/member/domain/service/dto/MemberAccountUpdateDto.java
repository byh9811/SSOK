package com.ssok.member.domain.service.dto;

import com.ssok.member.domain.api.dto.request.MemberAccountUpdateRequest;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberAccountUpdateDto {
    private Long memberSeq;
    private String memberAccountNum;

    public static MemberAccountUpdateDto of(MemberAccountUpdateRequest memberAccountUpdateRequest){
        return MemberAccountUpdateDto.builder()
                .memberSeq(memberAccountUpdateRequest.getMemberSeq())
                .memberAccountNum(memberAccountUpdateRequest.getMemberAccountNum())
                .build();
    }
}
