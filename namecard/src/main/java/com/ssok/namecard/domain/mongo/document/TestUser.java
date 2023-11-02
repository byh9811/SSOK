package com.ssok.namecard.domain.mongo.document;

import javax.persistence.Id;
import lombok.Getter;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Document(collection = "users")
@Getter
@ToString
public class TestUser {
    @Id
    private String id;

    @Field
    private String name;

    @Field
    private int age;
}
