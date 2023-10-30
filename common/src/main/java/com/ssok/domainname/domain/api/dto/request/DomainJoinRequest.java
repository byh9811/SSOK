package com.ssok.domainname.domain.api.dto.request;

import lombok.Builder;

@Builder
public record DomainJoinRequest(String nickname, int age) {

}