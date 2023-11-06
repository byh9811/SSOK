package com.ssok.base.domain.api.dto.response;

import lombok.Builder;

import java.time.YearMonth;
import java.util.Map;

public class PocketDetailAllResponse {
    private Map<YearMonth, PocketDetailResponses> pocketDetailMap;
    private Long pocketSaving;

    @Builder
    public PocketDetailAllResponse(Map<YearMonth, PocketDetailResponses> pocketDetailMap, Long pocketSaving) {
        this.pocketDetailMap = pocketDetailMap;
        this.pocketSaving = pocketSaving;
    }
}
