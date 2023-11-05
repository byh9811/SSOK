package com.ssok.mydata.domain.pos.api.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ssok.mydata.domain.pos.api.dto.inner.InnerItemListResponse;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@Getter
@AllArgsConstructor
public class ItemListResponse {

    @JsonProperty("item_list")
    List<InnerItemListResponse> itemList;

}
