package com.ssok.base.domain.mongo.document;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.persistence.Id;

@Document(collection = "pocket_main")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class PocketMain {
    @Id
    private Long memberSeq;

    private Long pocketSaving;
    // 레벨 , 경험치


    @Builder
    public PocketMain(Long memberSeq, Long pocketSaving) {
        this.memberSeq = memberSeq;
        this.pocketSaving = pocketSaving;
    }
}
