package com.ssok.member.domain.service.dto;

import com.ssok.member.domain.api.dto.request.MemberCreateRequest;
import com.ssok.member.domain.entity.Member;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberCreateDto {
    private String loginId;
    private String password; //비밀번호
    private String name;//이름
    private String phone; //전화번호
    private String simplePassword;

    public static MemberCreateDto of(MemberCreateRequest memberCreateRequest){
        return MemberCreateDto.builder()
                .loginId(memberCreateRequest.getLoginId())
                .password(memberCreateRequest.getPassword())
                .name(memberCreateRequest.getName())
                .phone(memberCreateRequest.getPhone())
                .simplePassword(memberCreateRequest.getSimplePassword())
                .build();
    }
    public Member toEntity() {
        return Member.builder()
                .memberId(this.loginId)
                .memberPassword(this.password)
                .memberName(this.name)
                .memberPhone(this.phone)
                .memberCi(UUID.randomUUID().toString())
                .memberCiCreateDate(LocalDateTime.now())
                .memberUuid(UUID.randomUUID().toString())
                .memberSimplePassword(this.simplePassword)
                .build();
    }
}
