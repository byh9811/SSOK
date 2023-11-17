package com.ssok.mydata.domain.pos.api;

import com.ssok.mydata.domain.bank.api.dto.request.AccountListRequest;
import com.ssok.mydata.domain.bank.api.dto.response.AccountListResponse;
import com.ssok.mydata.domain.pos.api.dto.inner.InnerItemListResponse;
import com.ssok.mydata.domain.pos.api.dto.response.ItemListResponse;
import com.ssok.mydata.domain.pos.entity.Item;
import com.ssok.mydata.domain.pos.service.ItemService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/pos/item-service/item")
public class ItemApi {

    private final ItemService itemService;

    @GetMapping("/list")
    public ResponseEntity<ItemListResponse> getItemList()
    {
        List<Item> itemList = itemService.getItemList();
        List<InnerItemListResponse> collect = itemList.stream().map(InnerItemListResponse::from).collect(Collectors.toList());
        return new ResponseEntity<>(new ItemListResponse(collect), HttpStatus.OK);
    }

}
