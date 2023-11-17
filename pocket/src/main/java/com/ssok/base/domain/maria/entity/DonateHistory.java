package com.ssok.base.domain.maria.entity;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class DonateHistory  {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "donate_history_seq")
    private Long donateHistorySeq;

//    @Id
    @OneToOne
    @JoinColumn(name = "pocket_history_seq")
    private PocketHistory pocketHistory;

    @ManyToOne
    @JoinColumn(name = "donate_seq")
    private Donate donate;

    @Builder
    public DonateHistory(PocketHistory pocketHistory, Donate donate) {
        this.pocketHistory = pocketHistory;
        this.donate = donate;
    }
}
