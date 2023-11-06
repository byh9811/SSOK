package com.ssok.receipt.global.enumerate;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class CardTypeConverter implements AttributeConverter<CardType, String> {

    @Override
    public String convertToDatabaseColumn(CardType attribute) {
        if (attribute == null) {
            return null;
        }
        return attribute.getCode();
    }

    @Override
    public CardType convertToEntityAttribute(String dbData) {
        if (dbData == null) {
            return null;
        }

        return CardType.fromCode(dbData);
    }
}
