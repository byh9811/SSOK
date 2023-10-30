package com.ssok.namecard.domain.api.dto.request;

import lombok.Builder;

@Builder
public record DomainJoinRequest(String nickname, int age) {

}