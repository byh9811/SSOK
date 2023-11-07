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

    public void exchangeNamecard(Namecard namecardA, Namecard namecardB, List<Exchange> exchangeList) {

        /** 메인페이지 업데이트 */

        /* A에게 보여질 명함 메인*/
        NamecardMainDoc namecardMainDocA = findByMemberSeq(namecardA.getMemberSeq());

        /* B에게 보여질 명함 메인*/
        NamecardMainDoc namecardMainDocB = findByMemberSeq(namecardB.getMemberSeq());
        log.info("1");
        NamecardDoc namecardDocA = NamecardDoc.from(namecardA);  //B 친구 명함 목록에 들어갈 A명함
        namecardDocA.addExchangeSeq(exchangeList.get(0).getExchangeSeq());
        NamecardDoc namecardDocB = NamecardDoc.from(namecardB); //A 친구 명함 목록에 들어갈 B명함
        namecardDocB.addExchangeSeq(exchangeList.get(1).getExchangeSeq());
        log.info("2");
        namecardDocA.addExchangeDate(exchangeList.get(0).getCreateDate().toLocalDate());
        namecardDocB.addExchangeDate(exchangeList.get(1).getCreateDate().toLocalDate());
        log.info("3");
        namecardMainDocA.addNamecardDoc(namecardDocB);
        namecardMainDocB.addNamecardDoc(namecardDocA);
        log.info("4");
        namecardMainDocMongoRepository.save(namecardMainDocA);
        namecardMainDocMongoRepository.save(namecardMainDocB);

        log.info("A의 명함 메인: {}", namecardMainDocA);
        log.info("B의 명함 메인: {}", namecardMainDocB);
        
        
        /** 상세 페이지 업데이트 */

        //memberB가 A를 보는 상세페이지
        NamecardDetailDoc namecardDetailDocB = NamecardDetailDoc.from(namecardA, exchangeList.get(1));

        //memberA가 B를 보는 상세페이지
        NamecardDetailDoc namecardDetailDocA = NamecardDetailDoc.from(namecardB, exchangeList.get(0));

        namecardDetailDocMongoRepository.save(namecardDetailDocA);
        namecardDetailDocMongoRepository.save(namecardDetailDocB);

        /** 명함 메모 초기화 */

        // A가 보는 B명함 메모 초기화
        NamecardMemoDoc namecardMemoDocA = new NamecardMemoDoc(exchangeList.get(0).getExchangeSeq(), "");

        // B가 보는 A명함 메모 초기화
        NamecardMemoDoc namecardMemoDocB = new NamecardMemoDoc(exchangeList.get(1).getExchangeSeq(), "");

        namecardMemoDocMongoRepository.save(namecardMemoDocA);
        namecardMemoDocMongoRepository.save(namecardMemoDocB);
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

        /* todo - 목록에 메모 최신화 */
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

    //todo - 즐겨찾기 최신화
    public void updateFavorite(Long memberSeq, Exchange exchange) {
        NamecardMainDoc namecardMainDoc = findByMemberSeq(exchange.getExchangeSeq());
        Namecard receiveNamecard = exchange.getReceiveNamecard();
        List<NamecardDoc> favorites = namecardMainDoc.getFavorites();
        //namecard -> namecardDoc
        NamecardDoc namecardDoc = NamecardDoc.from(receiveNamecard);
        favorites.add(namecardDoc);
        namecardMainDocMongoRepository.save(namecardMainDoc);
    }
}
