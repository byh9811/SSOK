package com.ssok.receipt.domain.mongo.document;

import com.ssok.receipt.domain.service.dto.ReceiptCreateServiceDto;
import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import javax.persistence.Id;
import java.time.LocalDateTime;


@Document(collection = "receipt_list")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Getter
public class ReceiptListDocument {

    @Id
    private String receiptListDocumentSeq;
    private String receiptDetailDocumentSeq;
    private Long memberSeq;
    private String shopName;
    private Long payAmt;
    private LocalDateTime approvedDate;
    private String transactionType;

    public static ReceiptListDocument fromCreateDto(String detailDocumentSeq, Long memberSeq, ReceiptCreateServiceDto dto) {
        return ReceiptListDocument.builder()
                .receiptDetailDocumentSeq(detailDocumentSeq)
                .memberSeq(memberSeq)
                .shopName(dto.receiptStoreName())
                .payAmt(dto.receiptAmount())
                .approvedDate(dto.receiptTransactionDatetime())
                .transactionType(dto.receiptType())
                .build();
    }
}
