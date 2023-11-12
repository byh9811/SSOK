package com.ssok.namecard.domain.maria.entity;

import com.ssok.namecard.global.entity.BaseEntity;
import java.time.LocalDate;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
public class Exchange extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long exchangeSeq;

    @ManyToOne
    @JoinColumn(name = "namecard_send_seq")
    private Namecard sendNamecard;

    @ManyToOne
    @JoinColumn(name = "namecard_receive_seq")
    private Namecard receiveNamecard;

    private Double exchangeLatitude;
    private Double exchangeLongitude;

    private String exchangeNote = "";
    private Boolean exchangeIsFavorite = false;

    @Enumerated(value = EnumType.STRING)
    private UpdateStatus updateStatus = UpdateStatus.CHECKED;

    //처음 교환된 명함의 생성날짜
    private LocalDate firstNamecardCreateDate;

    public void editMemo(String content) {
        this.exchangeNote = content;
    }

    public void updateFavorite() {
        this.exchangeIsFavorite = !this.exchangeIsFavorite;
    }

    public void toUpdated() {
        this.updateStatus = UpdateStatus.UPDATED;
    }

    public void toChecked() {
        this.updateStatus = UpdateStatus.CHECKED;
    }

    public void updateNamecard(Namecard latestNamecard) {
        this.receiveNamecard = latestNamecard;
    }

    public void updateFirstDate(LocalDate localDate) {
        this.firstNamecardCreateDate = localDate;
    }
}
