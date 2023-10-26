package com.ssok.base.domain.api.dto.request;

import lombok.Builder;

@Builder
public record DomainJoinRequest(String nickname, int age) {

}