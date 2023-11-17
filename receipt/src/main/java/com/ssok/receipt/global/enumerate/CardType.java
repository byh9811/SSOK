package com.ssok.receipt.global.enumerate;

public enum CardType {
    CREDIT("01", "신용"),
    CHECK("02", "체크"),
    SMALL_CREDIT_CHECK("03", "소액신용체크");

    private final String code;
    private final String description;

    CardType(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    public static CardType fromCode(String code) {
        for (CardType type : CardType.values()) {
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
