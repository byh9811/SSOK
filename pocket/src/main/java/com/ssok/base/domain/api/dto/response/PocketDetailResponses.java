package com.ssok.base.domain.api.dto.response;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class PocketDetailResponses {

    // 월별 데이터
    private List<PocketDetailResponse> pocketDetailResponses;
    // 월별 데이터 개수
    private Integer totalHistory;
    //입금 총액
    private Long deposit;
    //출금 총액
    private Long withdrawal;

    @Builder
    public PocketDetailResponses(List<PocketDetailResponse> pocketDetailResponses, Integer totalHistory, Long deposit, Long withdrawal) {
        this.pocketDetailResponses = pocketDetailResponses;
        this.totalHistory = totalHistory;
        this.deposit = deposit;
        this.withdrawal = withdrawal;
    }
}
