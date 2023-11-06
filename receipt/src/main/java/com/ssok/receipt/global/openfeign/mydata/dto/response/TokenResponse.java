package com.ssok.receipt.global.openfeign.mydata.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class TokenResponse {

    private String token_type;

    private String access_token;

    private String expires_in;

    private String refresh_token;

    private String refresh_token_expires_in;

    private String scope;

}
