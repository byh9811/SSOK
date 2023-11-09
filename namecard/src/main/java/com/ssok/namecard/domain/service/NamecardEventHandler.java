package com.ssok.namecard.domain.service;

import com.ssok.namecard.domain.exception.MemoDetailException;
import com.ssok.namecard.domain.exception.NamecardDocException;
import com.ssok.namecard.domain.maria.entity.Exchange;
import com.ssok.namecard.domain.maria.entity.Namecard;
import com.ssok.namecard.domain.mongo.document.NamecardDetailDoc;
import com.ssok.namecard.domain.mongo.document.NamecardMainDoc;
import com.ssok.namecard.domain.mongo.document.NamecardMainDoc.NamecardDoc;
import com.ssok.namecard.domain.mongo.document.NamecardMemoDoc;
import com.ssok.namecard.domain.mongo.repository.NamecardDetailDocMongoRepository;
import com.ssok.namecard.domain.mongo.repository.NamecardMainDocMongoRepository;
import com.ssok.namecard.domain.mongo.repository.NamecardMemoDocMongoRepository;
import com.ssok.namecard.global.exception.ErrorCode;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class NamecardEventHandler {

    private final NamecardMainDocMongoRepository namecardMainDocMongoRepository;
    private final NamecardMemoDocMongoRepository namecardMemoDocMongoRepository;
    private final NamecardDetailDocMongoRepository namecardDetailDocMongoRepository;

    public NamecardMainDoc findByNamecardSeq(Long seq){
        return namecardMainDocMongoRepository.findByNamecardSeq(seq)
                                   .orElseThrow(
                                       () -> new NamecardDocException(ErrorCode.MONGO_NAMECARD_NOT_FOUND)
                                   );
    }

    public NamecardMainDoc findByMemberSeq(Long seq){
        return namecardMainDocMongoRepository.findByMemberSeq(seq)
                                             .orElseThrow(
                                                 () -> new NamecardDocException(ErrorCode.MONGO_NAMECARD_NOT_FOUND)
                                             );
    }

    public void createNamecard(Namecard namecard) {
        NamecardMainDoc namecardMainDoc = NamecardMainDoc.from(namecard);
        namecardMainDocMongoRepository.save(namecardMainDoc);
    }

    public void exchangeNamecard(Namecard namecardA, Namecard namecardB, Exchange exchange) {

        /** 메인페이지 업데이트 */
        /* A에게 보여질 명함 메인*/
        NamecardMainDoc namecardMainDocA = findByMemberSeq(namecardA.getMemberSeq());
        NamecardDoc namecardDocB = NamecardDoc.from(namecardB); //A 친구 명함 목록에 들어갈 B명함
        namecardDocB.addExchangeSeq(exchange.getExchangeSeq());
        namecardDocB.addExchangeDate(exchange.getCreateDate().toLocalDate());
        namecardMainDocA.addNamecardDoc(namecardDocB);
        namecardMainDocMongoRepository.save(namecardMainDocA);
        log.info("A의 명함 메인: {}", namecardMainDocA);


        /** 상세 페이지 업데이트 */
        //memberA가 B를 보는 상세페이지
        NamecardDetailDoc namecardDetailDocA = NamecardDetailDoc.from(namecardB, exchange);
        namecardDetailDocMongoRepository.save(namecardDetailDocA);

        /** 명함 메모 초기화 */
        // A가 보는 B명함 메모 초기화
        NamecardMemoDoc namecardMemoDocA = new NamecardMemoDoc(exchange.getExchangeSeq(), "");
        namecardMemoDocMongoRepository.save(namecardMemoDocA);
    }

    public void editMemo(Long memberSeq, Exchange exchange, String content) {
        log.info("exchange: {}", exchange);
        log.info("content: {}", content);
        NamecardMemoDoc namecardMemoDoc = namecardMemoDocMongoRepository.findByExchangeSeq(exchange.getExchangeSeq())
                                                                    .orElseThrow(
                                                                      () -> new MemoDetailException(
                                                                          ErrorCode.MONGO_MEMO_NOT_FOUND)
                                                                  );
        log.info("변경전 메모: {}", namecardMemoDoc.getMemo());
        namecardMemoDoc.editMemo(content);
        log.info("변경 후 메모: {}", namecardMemoDoc.getMemo());
        namecardMemoDocMongoRepository.save(namecardMemoDoc);

        /* 목록에 메모 최신화 */
        NamecardMainDoc findNamecardMainDoc = findByMemberSeq(memberSeq);
        List<NamecardDoc> namecards = findNamecardMainDoc.getNamecards();

        //NamecardDoc의 exchangeSeq가 exchange.exchangeSeq인 것을 찾고 해당 NamecardDoc의 exchangeNote를 업데이트 함.(namecard.update(content);)
        for (NamecardDoc namecard : namecards) {
            if (namecard.getExchangeSeq().equals(exchange.getExchangeSeq())) {
                log.info("변경 전 교환 노트: {}", namecard.getExchangeNote());
                namecard.update(content);
                log.info("변경 후 교환 노트: {}", namecard.getExchangeNote());
                namecardMainDocMongoRepository.save(findNamecardMainDoc);
                break;
            }
        }

    }

    public void updateFavorite(Exchange exchange) {
        NamecardMainDoc namecardMainDoc = findByMemberSeq(exchange.getExchangeSeq());
        Namecard receiveNamecard = exchange.getReceiveNamecard();
        List<NamecardDoc> favorites = namecardMainDoc.getFavorites();
        //namecard -> namecardDoc
        NamecardDoc namecardDoc = NamecardDoc.from(receiveNamecard);
        Optional<NamecardDoc> existingFavorite = favorites.stream()
                                                          .filter(fav -> fav.getExchangeSeq()
                                                                            .equals(
                                                                                namecardDoc.getExchangeSeq()))
                                                          .findFirst();
        if (existingFavorite.isPresent()) {
            favorites.remove(existingFavorite.get());
        } else {
            favorites.add(namecardDoc);
        }
        namecardMainDocMongoRepository.save(namecardMainDoc);
    }
}
