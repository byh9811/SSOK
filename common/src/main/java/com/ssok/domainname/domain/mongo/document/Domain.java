package com.ssok.domainname.domain.mongo.document;

import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import javax.persistence.Id;


@Document(collection = "test")
public class Domain {

    @Id
    private String id;

    @Field
    private String name;

    @Field
    private int age;

}
