package com.ssok.idcard.global.openfeign.naver.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.apache.tomcat.jni.Address;

import java.util.List;

import static lombok.AccessLevel.PUBLIC;

@Getter
@AllArgsConstructor
@NoArgsConstructor(access = PUBLIC)
@ToString
public class LicenseOcrResponse {
    List<Images> images;

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Images {
        private IdCard idCard;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class IdCard {
        private Result result;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Result {
        private DriverLicense dl;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class DriverLicense {
        private List<Type> type;
        private List<LicenseNumber> num;
        private List<Name> name;
        private List<PersonalNum> personalNum;
        private List<Address> address;
        private List<RenewStartDate> renewStartDate;
        private List<RenewEndDate> renewEndDate;
        private List<Condition> condition;
        private List<Code> code;
        private List<IssueDate> issueDate;
        private List<Authority> authority;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Type {
        private String text;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class LicenseNumber {
        private StringObject formatted;
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
    public static class PersonalNum {
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
    public static class RenewStartDate {
        private DateObject formatted;

    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class RenewEndDate {
        private DateObject formatted;

    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Condition {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Code {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class IssueDate {
        private DateObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class Authority {
        private StringObject formatted;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class StringObject {
        private String value;
    }

    @Getter
    @AllArgsConstructor
    @NoArgsConstructor(access = PUBLIC)
    public static class DateObject {
        private String year;
        private String month;
        private String day;
    }

}
