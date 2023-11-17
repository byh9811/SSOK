package com.ssok.idcard.domain.api.request;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.regex.Pattern;

import static com.ssok.idcard.global.util.ValidateUtil.PERSONAL_NUMBER_PATTERN;

public record LicenseCreateRequest(
        String licenseName,
        String licensePersonalNumber,
        String licenseType,
        String licenseAddress,
        String licenseNumber,
        LocalDate licenseRenewStartDate,
        LocalDate licenseRenewEndDate,
        String licenseCondition,
        String licenseCode,
        LocalDate licenseIssueDate,
        String licenseAuthority
) {

//    public LicenseCreateRequest {
//        if (!PERSONAL_NUMBER_PATTERN.matcher(licensePersonalNumber).matches()) {
//            throw new IllegalArgumentException("Personal number must be in the format XXXXXX-XXXXXXX");
//        }
//    }

    public static LicenseCreateRequest of(
            String licenseName,
            String licensePersonalNumber,
            String licenseType,
            String licenseAddress,
            String licenseNumber,
            LocalDate licenseRenewStartDate,
            LocalDate licenseRenewEndDate,
            String licenseCondition,
            String licenseCode,
            LocalDate licenseIssueDate,
            String licenseAuthority
    ){
        return new LicenseCreateRequest(
                licenseName,
                licensePersonalNumber,
                licenseType,
                licenseAddress,
                licenseNumber,
                licenseRenewStartDate,
                licenseRenewEndDate,
                licenseCondition,
                licenseCode,
                licenseIssueDate,
                licenseAuthority);
    }

    public String validate(){
        // 이름에 숫자 또는 특수문자가 들어갈 경우
        if(licenseName.matches(".*[0-9!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")){
            return "Name cannot contain digits or special characters";
        }

        // 주민등록번호가 null값이거나 숫자, "-"외의 문자가 들어갈 경우
        if (licensePersonalNumber == null) {
            return "licensePersonalNumber cannot be null";
        }
        if (!licensePersonalNumber.matches("[0-9-]+")) {
            return "licensePersonalNumber can only contain digits and '-'";
        }

        // 면허 타입엔 특수문자가 들어갈 수 없음
        if(licenseType.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")){
            return "licenseType cannot contain specail characters";
        }
        if(licenseType == null){
            return "licenseType cannot be null";
        }

        // 주소는 빈칸 또는 200자 이상일 수 없음
        if(licenseAddress == null){
            return "licenseAddress cannot be null";
        }
        if (licenseAddress.length() > 200) {
            return "licenseAddress length cannot exceed 200 characters";
        }

        // license Number은 숫자와 하이픈을 제외한 문자가 들어갈 수 없음
        if (licenseNumber == null) {
            return "licenseNumber cannot be null";
        }
        if (!licenseNumber.matches("[0-9-]+")) {
            return "licenseNumber can only contain digits and '-'";
        }

        // 면허 갱신기간의 타입을 맞춰주어야하며, null일 수 없음
        try {
            String temp = licenseRenewStartDate.toString();
            LocalDate.parse(temp);
        } catch (DateTimeParseException e) {
            return "Invalid issue date format. Please use the 'yyyy-MM-dd' format.";
        }
        if(licenseRenewStartDate == null){
            return "licenseRenewStartDate cannot be null";
        }

        try {
            String temp = licenseRenewEndDate.toString();
            LocalDate.parse(temp);
        } catch (DateTimeParseException e) {
            return "Invalid issue date format. Please use the 'yyyy-MM-dd' format.";
        }
        if(licenseRenewEndDate == null){
            return "licenseRenewEndDate cannot be null";
        }

        if (licenseCode == null || licenseCode.length() != 6 || !licenseCode.matches("[a-zA-Z0-9]+")) {
            throw new IllegalArgumentException("License code must be alphanumeric and have a length of 6");
        }

        // 발급일자는 date형식이어야 하며, null일 수 없음
        try {
            String temp = licenseIssueDate.toString();
            LocalDate.parse(temp);
        } catch (DateTimeParseException e) {
            return "Invalid issue date format. Please use the 'yyyy-MM-dd' format.";
        }
        if(licenseIssueDate == null){
            return "licenseRenewEndDate cannot be null";
        }

        // 면허의 발급기관을 명시해주어야 함
        if(licenseAuthority.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")){
            return "license authority cannot contain specail characters";
        }
        if(licenseAuthority == null){
            return "licenseAuthority cannot be null";
        }

        return null;
    }
}
