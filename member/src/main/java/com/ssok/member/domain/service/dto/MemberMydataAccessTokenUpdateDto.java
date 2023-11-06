package com.ssok.member.domain.service.dto;

import com.ssok.member.domain.api.dto.request.MemberMydataAccessTokenUpdateRequest;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberMydataAccessTokenUpdateDto {
    private Long memberSeq;
    private String memberMydataAccessToken;

    public static MemberMydataAccessTokenUpdateDto of(MemberMydataAccessTokenUpdateRequest memberMydataAccessTokenUpdateRequest){
        return MemberMydataAccessTokenUpdateDto.builder()
                .memberSeq(memberMydataAccessTokenUpdateRequest.getMemberSeq())
                .memberMydataAccessToken(memberMydataAccessTokenUpdateRequest.getMemberMydataAccessToken())
                .build();
    }
}
