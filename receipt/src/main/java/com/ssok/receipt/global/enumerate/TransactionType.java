package com.ssok.receipt.global.enumerate;

public enum TransactionType {
    APPROVAL("01", "승인"),
    CANCELLATION("02", "승인취소"),
    CORRECTION("03", "정정");

    private final String code;
    private final String description;

    TransactionType(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    public static TransactionType fromCode(String code) {
        for (TransactionType type : TransactionType.values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown code: " + code);
    }

    @Override
    public String toString() {
        return this.code + ": " + this.description;
    }

}
