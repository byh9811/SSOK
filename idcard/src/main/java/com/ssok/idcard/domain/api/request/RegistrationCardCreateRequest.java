package com.ssok.idcard.domain.api.request;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import static com.ssok.idcard.global.util.ValidateUtil.PERSONAL_NUMBER_PATTERN;

public record RegistrationCardCreateRequest(
        String registrationCardName,
        String registrationCardPersonalNumber,
        String registrationCardAddress,
        LocalDate registrationCardIssueDate,
        String registrationCardAuthority
) {

//    public RegistrationCardCreateRequest {
//        if (!PERSONAL_NUMBER_PATTERN.matcher(registrationCardPersonalNumber).matches()) {
//            throw new IllegalArgumentException("Personal number must be in the format XXXXXX-XXXXXXX");
//        }
//    }


    public String validate() {
        // Validate registrationCardName
        if (registrationCardName.matches(".*[0-9!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
            return "Name cannot contain digits or special characters";
        }

        // Validate registrationCardPersonalNumber
        if (registrationCardPersonalNumber == null) {
            return "Personal number cannot be null";
        }
        // Check if registrationCardPersonalNumber contains only digits and "-"
        if (!registrationCardPersonalNumber.matches("[0-9-]+")) {
            return "Personal number can only contain digits and '-'";
        }

        // Validate registrationCardAddress
        if(registrationCardAddress == null){
            return "registrationCardAddress cannot be null";
        }
        if (registrationCardAddress.length() > 200) {
            return "Address length cannot exceed 200 characters";
        }

        // Validate registrationCardIssueDate
        try {
            String temp = registrationCardIssueDate.toString();
            LocalDate.parse(temp);
        } catch (DateTimeParseException e) {
            return "Invalid issue date format. Please use the 'yyyy-MM-dd' format.";
        }

        // Validate registrationCardAuthority
        if (registrationCardAuthority == null) {
            return "registrationCardAuthority cannot be null";
        }

        // If all validations pass, return null (indicating success)
        return null;
    }
}
