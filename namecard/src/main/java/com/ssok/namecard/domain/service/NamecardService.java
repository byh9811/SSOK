package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.maria.entity.Namecard;
import com.ssok.namecard.domain.maria.repository.NamecardRepository;
import com.ssok.namecard.domain.service.dto.NamecardCreateRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class NamecardService {

    private final NamecardRepository namecardRepository;

    public void createNamecard(NamecardCreateRequest namecardCreateRequest, Long memberId) {
        Namecard namecard = Namecard.fromRequest(namecardCreateRequest, memberId);
        namecardRepository.save(namecard);
    }
}
