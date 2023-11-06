package com.ssok.namecard.domain.mongo.document;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "namecard_memo")
@Builder
@ToString
@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class NamecardMemoDoc {

    @Id
    Long exchangeSeq;
    String memo;

    public void editMemo(String content) {
        this.memo = content;
    }
}
