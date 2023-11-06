package com.ssok.receipt.global.enumerate;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class TransactionTypeConverter implements AttributeConverter<TransactionType, String> {

    @Override
    public String convertToDatabaseColumn(TransactionType attribute) {
        if (attribute == null) {
            return null;
        }
        return attribute.getCode();
    }

    @Override
    public TransactionType convertToEntityAttribute(String dbData) {
        if (dbData == null) {
            return null;
        }

        for (TransactionType type : TransactionType.values()) {
            if (type.getCode().equals(dbData)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown database value: " + dbData);
    }
}
