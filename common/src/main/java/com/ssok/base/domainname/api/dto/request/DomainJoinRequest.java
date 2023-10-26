package com.ssok.base.domainname.api.dto.request;

import lombok.Builder;

@Builder
public record DomainJoinRequest(String nickname, int age) {

}