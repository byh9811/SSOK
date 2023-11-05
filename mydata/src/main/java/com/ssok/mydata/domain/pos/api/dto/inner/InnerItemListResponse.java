package com.ssok.mydata.domain.pos.api.dto.inner;

import com.ssok.mydata.domain.pos.entity.Item;
import lombok.AllArgsConstructor;

@AllArgsConstructor
public class InnerItemListResponse {

    private Long itemSeq;

    private String itemName;

    private Long itemPrice;

    private String itemNumber;

    public static InnerItemListResponse from(Item item) {
        return new InnerItemListResponse(item.getItemSeq(), item.getItemName(), item.getItemPrice(), item.getItemNumber());
    }

}
