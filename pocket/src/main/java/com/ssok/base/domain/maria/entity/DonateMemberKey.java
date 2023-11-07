package com.ssok.base.domain.maria.entity;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
public class DonateMemberKey implements Serializable {
    private Donate donate;
    private Long memberSeq;

    @Builder
    public DonateMemberKey(Donate donate, Long memberSeq) {
        this.donate = donate;
        this.memberSeq = memberSeq;
    }
}
