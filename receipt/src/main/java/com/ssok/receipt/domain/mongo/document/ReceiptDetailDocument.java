package com.ssok.receipt.domain.mongo.document;

import com.ssok.receipt.domain.api.dto.inner.InnerPaymentItem;
import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;

import javax.persistence.Id;
import java.time.LocalDateTime;
import java.util.List;


@Document(collection = "receipt_detail")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Getter
public class ReceiptDetailDocument {

    @Id
    private String receiptDetailDocumentSeq;
    private String cardCompany;
    private String cardNumberFirstSection;
    private String cardType;
    private String transactionType;
    private String approvedNum;
    private LocalDateTime approvedDate;
    private String shopName;
    private Long payAmt;
    private List<InnerPaymentItem> paymentItemList;

    public static ReceiptDetailDocument fromCreateDto(ReceiptCreateServiceDto dto) {
        return ReceiptDetailDocument.builder()
                .shopName(dto.receiptStoreName())
                .payAmt(dto.receiptAmount())
                .approvedDate(dto.receiptTransactionDatetime())
                .transactionType(dto.receiptType())
                .paymentItemList(dto.paymentItemList())
                .build();
    }
}
