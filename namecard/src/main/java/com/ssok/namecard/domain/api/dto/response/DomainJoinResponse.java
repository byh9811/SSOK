package com.ssok.namecard.domain.api.dto.response;

import lombok.Builder;

@Builder
public record DomainJoinResponse(String nickname, int age) {

}