package com.ssok.mydata.domain.pos.api.dto.inner;

import com.ssok.mydata.domain.pos.entity.Item;
import com.ssok.mydata.domain.pos.entity.Payment;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class InnerPaymentItem {

    private Long itemSeq;

    private Long paymentItemCnt;

}
