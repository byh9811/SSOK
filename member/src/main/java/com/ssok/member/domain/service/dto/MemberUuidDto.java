package com.ssok.member.domain.service.dto;

import com.ssok.member.domain.api.dto.request.MemberSeqRequest;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberUuidDto {
    private String uuid;

    public static MemberUuidDto of(MemberSeqRequest memberSeqRequest){
        return MemberUuidDto.builder()
                .uuid(memberSeqRequest.getMemberUuid())
                .build();
    }
}
