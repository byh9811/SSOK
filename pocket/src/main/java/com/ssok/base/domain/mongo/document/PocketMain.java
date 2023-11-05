package com.ssok.base.domain.mongo.document;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.persistence.Id;
import java.time.LocalDateTime;

@Document(collection = "pocket_main")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class PocketMain {
    @Id
    private Long memberSeq;

    private Long pocketSaving;
    // 레벨 , 경험치

    private LocalDateTime createDate;

    private LocalDateTime modifyDate;


    @Builder
    public PocketMain(Long memberSeq, Long pocketSaving, LocalDateTime createDate, LocalDateTime modifyDate) {
        this.memberSeq = memberSeq;
        this.pocketSaving = pocketSaving;
        this.createDate = createDate;
        this.modifyDate = modifyDate;
    }
}
