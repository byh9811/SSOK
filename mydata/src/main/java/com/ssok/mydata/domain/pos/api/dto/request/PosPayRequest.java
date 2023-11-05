package com.ssok.mydata.domain.pos.api.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ssok.mydata.domain.card.api.dto.request.PayRequest;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class PosPayRequest {

        private String accessToken; // 쏙 접근 토큰

        private PayRequest payRequest; // 결제 정보

}