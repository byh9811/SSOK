package com.ssok.member.domain.service.dto;

import com.ssok.member.domain.api.dto.request.MemberAccountRequest;
import com.ssok.member.domain.api.dto.request.MemberSeqRequest;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberAccountDto {
    private Long memberSeq;

    public static MemberAccountDto of(MemberAccountRequest memberAccountRequest){
        return MemberAccountDto.builder()
                .memberSeq(memberAccountRequest.getMemberSeq())
                .build();
    }
}
