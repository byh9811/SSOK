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
public class MemberUUIDDto {
    private String UUID;

    public static MemberUUIDDto of(MemberSeqRequest memberSeqRequest){
        return MemberUUIDDto.builder()
                .UUID(memberSeqRequest.getUUID())
                .build();
    }
}
