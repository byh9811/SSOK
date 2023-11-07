package com.ssok.receipt.domain.maria.entity;

import com.ssok.receipt.domain.api.dto.inner.InnerPaymentItem;
import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
import com.ssok.receipt.global.entity.BaseEntity;
import com.ssok.receipt.global.enumerate.CardType;
import com.ssok.receipt.global.enumerate.CardTypeConverter;
import com.ssok.receipt.global.enumerate.TransactionType;
import com.ssok.receipt.global.enumerate.TransactionTypeConverter;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@SuperBuilder
public class PurchaseItem extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long purchaseItemSeq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receipt_seq")
    private Receipt receipt;

    private String purchaseItemName;

    private Long purchaseItemCnt;

    private Long purchaseItemPrice;

    private boolean isCarbonNeutral;

    public static PurchaseItem from(Receipt receipt, InnerPaymentItem item, boolean isCarbonNeutral) {
        return PurchaseItem.builder()
                .receipt(receipt)
                .purchaseItemName(item.itemName())
                .purchaseItemCnt(item.itemCnt())
                .purchaseItemPrice(item.itemPrice())
                .isCarbonNeutral(isCarbonNeutral)
                .build();
    }
}
