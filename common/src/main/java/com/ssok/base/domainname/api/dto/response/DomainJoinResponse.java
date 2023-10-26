package com.ssok.base.domainname.api.dto.response;

import lombok.Builder;

@Builder
public record DomainJoinResponse(String nickname, int age) {

}