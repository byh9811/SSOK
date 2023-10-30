package com.ssok.namecard.domain.mongo.document;

import javax.persistence.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;


@Document(collection = "test")
public class Namecard {

    @Id
    private String id;

    @Field
    private String name;

    @Field
    private int age;

}
