package com.ssok.mydata.domain.pos.service;

import com.ssok.mydata.domain.card.api.dto.request.TransactionRequest;
import com.ssok.mydata.domain.card.api.dto.response.PayResponse;
import com.ssok.mydata.domain.card.entity.Card;
import com.ssok.mydata.domain.card.entity.CardHistory;
import com.ssok.mydata.domain.card.repository.CardHistoryRepository;
import com.ssok.mydata.domain.card.repository.CardRepository;
import com.ssok.mydata.domain.pos.entity.Item;
import com.ssok.mydata.domain.pos.repository.ItemRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class ItemService {

    private final ItemRepository itemRepository;

    public List<Item> getItemList() {
        return itemRepository.findAll();
    }

}
