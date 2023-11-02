package com.ssok.receipt.domain.mongo.document;

import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import javax.persistence.Id;


@Document(collection = "receipt")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Getter
public class Receipt {

    @Id
    private String id;

    @Field
    private String name;

    @Field
    private int age;

}
