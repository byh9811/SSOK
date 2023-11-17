package com.ssok.base.domain.mongo.document;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.web.bind.annotation.GetMapping;

import javax.persistence.Id;


@Document(collection = "test")
@Getter
@Setter
public class Domain {

    @Id
    private String id;

    @Field
    private String name;

    @Field
    private int age;

}
