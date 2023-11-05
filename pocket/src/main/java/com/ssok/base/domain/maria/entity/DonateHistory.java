package com.ssok.base.domain.maria.entity;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class DonateHistory {
    @Id @OneToOne
    @JoinColumn(name = "pocket_history_seq")
    PocketHistory pocketHistory;

    @ManyToOne
    @JoinColumn(name = "donate_seq")
    private Donate donate;

    @Builder
    public DonateHistory(PocketHistory pocketHistory, Donate donate) {
        this.pocketHistory = pocketHistory;
        this.donate = donate;
    }
}
