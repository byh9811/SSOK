package com.ssok.mydata.domain.pos.api.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ssok.mydata.domain.pos.api.dto.inner.InnerItemListResponse;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ItemListResponse {

    List<InnerItemListResponse> itemList;

}
