package com.ssok.idcard.global.openfeign.naver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

import static lombok.AccessLevel.PUBLIC;

@Getter
@AllArgsConstructor
@NoArgsConstructor(access = PUBLIC)
@ToString
public class NameCardOcrResponse {
    List<Images> images;

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Images {
        private NameCard nameCard;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class NameCard {
        private Result result;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    @ToString
    public static class Result {
        private List<Name> name;
        private List<Company> company;
        private List<Department> department;
        private List<Address> address;
        private List<Position> position;
        private List<Mobile> mobile;
        private List<Tel> tel;
        private List<Fax> fax;
        private List<Email> email;
        private List<Homepage> homepage;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Name {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Company {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Address {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Department {
        private StringObject formatted;

    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Position {
        private StringObject formatted;

    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Mobile {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Tel {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Fax {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Email {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Homepage {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class StringObject {
        private String value;
    }

}
