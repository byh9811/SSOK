package com.ssok.member.domain.service;

import com.ssok.member.domain.api.dto.request.MemberSimplePasswordCheckRequest;
import com.ssok.member.domain.api.dto.response.MemberAccountResponse;
import com.ssok.member.domain.api.dto.response.MemberSeqResponse;
import com.ssok.member.domain.api.dto.response.TokenResponse;
import com.ssok.member.domain.entity.Member;
import com.ssok.member.domain.repository.MemberRepository;
import com.ssok.member.domain.service.dto.*;
import com.ssok.member.domain.token.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class MemberService {
    private final MemberQService memberQService;
    private final MemberRepository memberRepository;
    private final JwtTokenProvider jwtTokenProvider;

//    private final TransactionService transactionService;
//    private final AuthAccessUtil authAccessUtil;

    public boolean checkId(String memberId){
        Member member = memberRepository.findMemberByMemberId(memberId).orElse(null);
        if(member == null)
            return true;
        return false;
    }
    public Long getSeq(String memberUuid){
        Member member = memberRepository.findMemberByMemberUuid(memberUuid).orElse(null);

        if(member==null){
            return null;
        }else{
            return member.getMemberSeq();
        }

//        return MemberSeqResponse.builder()
//                .memberSeq(member.getMemberSeq())
//                .build();
    }

    public String getAccount(Long memberSeq) {
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElse(null);
        if(member==null){
            return null;
        }else{
            return member.getMemberAccountNum();
        }
//        return MemberAccountResponse.builder()
//                .memberAccountNum(member.getMemberAccountNum())
//                .build();
    }
    public MemberAccountResponse editAccountNum(MemberAccountUpdateDto memberAccountUpdateDto){
        Long memberSeq = memberAccountUpdateDto.getMemberSeq();
        String memberAccountNum = memberAccountUpdateDto.getMemberAccountNum();
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElseThrow();
        member.updateAccountNum(memberAccountNum);
        return MemberAccountResponse.builder().memberAccountNum(memberAccountNum).build();
    }
    public String getMydataAccessToken(Long memberSeq) {
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElse(null);
        if(member==null)
            return null;
        String memberMydataAccessToken = member.getMemberMydataAccessToken();
        return memberMydataAccessToken;
    }
    public String editMydataAccessToken(MemberMydataAccessTokenUpdateDto memberMydataAccessTokenUpdateDto){
        Long memberSeq = memberMydataAccessTokenUpdateDto.getMemberSeq();
        String memberMydataAccessToken = memberMydataAccessTokenUpdateDto.getMemberMydataAccessToken();
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElseThrow();
        member.updateMydataAccessToken(memberMydataAccessToken);
        return member.getMemberMydataAccessToken();
    }
    public Boolean getSaving(Long memberSeq) {
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElseThrow();
        return member.isSaving();
    }
    public Boolean editSaving(Long memberSeq) {
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElseThrow();
        member.changeSaving();
        return member.isSaving();
    }
    public Boolean getVerification(Long memberSeq) {
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElseThrow();
        return member.isVerification();
    }
    public Boolean editVerification(Long memberSeq) {
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElseThrow();
        member.changeVerification();
        return member.isVerification();
    }
    public void save(MemberCreateDto memberCreateDto) {
        String loginId = memberCreateDto.getLoginId();
        Member findMember = memberRepository.findMemberByMemberId(loginId).orElse(null);
        if(findMember==null){
            Member member = memberCreateDto.toEntity();
            memberRepository.save(member);
        }
    }

    public TokenResponse login(MemberLoginDto memberLoginDto) {

        Member member = memberRepository.findMemberByMemberIdAndMemberPassword(memberLoginDto.getLoginId(), memberLoginDto.getPassword()).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));
        //둘 다 새로 발급
        String accessToken = jwtTokenProvider.createAccessToken(member.getMemberUuid());
        String refreshToken = jwtTokenProvider.createRefreshToken(member.getMemberUuid());
        member.updateRefreshToken(refreshToken);   //DB Refresh 토큰 갱신
        return TokenResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .memberName(member.getMemberName())
                .loginId(member.getMemberId())
                .serviceAgreement(member.isServiceAgreement())
                .build();
    }

    public String getUuid(String refreshToken) {
        Member member = memberRepository.findMemberByMemberRefreshToken(refreshToken).orElse(null);
        return member.getMemberUuid();
    }

    public String getCi(Long memberSeq) {
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElse(null);
        return member.getMemberCi();

    }

    public String getName(Long memberSeq) {
        Member member = memberRepository.findMemberByMemberSeq(memberSeq).orElse(null);
        return member.getMemberName();
    }

    public void logout(String memberId) {
        Member member = memberRepository.findMemberByMemberId(memberId).orElse(null);
        if(member!=null){
            member.deleteRefreshToken();
        }
    }

    public void editAgreement(String memberId) {
        Member member = memberRepository.findMemberByMemberId(memberId).orElse(null);
        if(member!=null){
            member.agreeService();
        }
    }

    public boolean checkSimplePassword(MemberSimplePasswordCheckDto memberSimplePasswordCheckDto) {
        Member member = memberRepository.findMemberByMemberId(memberSimplePasswordCheckDto.getLoginId()).orElse(null);
        if(member!=null){
            if(member.getMemberSimplePassword().equals(memberSimplePasswordCheckDto.getSimplePassword())){
                return true;
            }
        }
        return false;
    }

//    public Member findById(Long id) {
//        return memberRepository.findById(id).orElseThrow(() -> new EntityNotFoundException());
//    }


//
//    public TokenResponse simpleLogin(HttpServletRequest request, SimpleLoginRequest simpleLoginRequest) {
//        String simplePassword = simpleLoginRequest.getSimplePassword();
//
//        String accessToken = "";
//        String refreshToken = jwtTokenProvider.resolveRefreshToken(request);
//
//        Claims claimsToken = jwtTokenProvider.getClaimsToken(refreshToken);
//        Long memberId = (long) (int) claimsToken.get("userId");
//        Member member = memberRepository.findById(memberId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));
//
//        //유저로부터 받은 RT의 기한이 유효한 경우
//        if (jwtTokenProvider.isValidRefreshToken(refreshToken)) {
//
//            // 입력받은 RT와 DB의 RT가 동일하다면
//            if (member.getRefreshToken().equals(refreshToken)) {
//                //입력받은 simple password가 동일하다면
//                if (member.getSimplePassword().equals(simplePassword)) {
//                    //둘 다 새로 발급
//                    accessToken = jwtTokenProvider.createAccessToken(member.getId());
//                    refreshToken = jwtTokenProvider.createRefreshToken(member.getId());
//                    member.updateRefreshToken(refreshToken);   //DB Refresh 토큰 갱신
//
//                    return TokenResponse.builder()
//                            .accessToken(accessToken)
//                            .refreshToken(refreshToken)
//                            .build();
//                }
//            }
//        } else {
//            member.changeAutoLogin(false);
//        }
//        return null;
//    }
//
//    public Boolean checkToken(HttpServletRequest request) {
//        String refreshToken = jwtTokenProvider.resolveRefreshToken(request);
//        Claims claimsToken = jwtTokenProvider.getClaimsToken(refreshToken);
//        Long userId = (long) (int) claimsToken.get("userId");
//        System.out.println("검증 토큰 : " + refreshToken + " 회원 아이디 : " + userId);
//        Member member = memberRepository.findById(userId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다."));
//        if (jwtTokenProvider.isValidRefreshToken(refreshToken) && member.getAutoLogin()) { // RT 값이 유효하고 autoLogin check 유저
//            String tokenFromDB = member.getRefreshToken();
//            System.out.println("tokenFromDB = " + tokenFromDB);
//            if (refreshToken.equals(tokenFromDB)) {   //DB의 refresh토큰과 지금들어온 토큰이 같은지 확인
//                return true;//동일하면 true 반환
//            } else {
//                //DB의 Refresh토큰과 들어온 Refresh토큰이 다르면 중간에 변조된 것임
//                System.out.println("Refresh Token 탈취");
//                member.deleteRefreshToken();
//                return false;
//            }
//        }
//        return false;
//    }
//
//    public TokenResponse issueAccessToken(HttpServletRequest request) throws IllegalAccessException {
//        String accessToken = jwtTokenProvider.resolveAccessToken(request);
//        String refreshToken = jwtTokenProvider.resolveRefreshToken(request);
//        System.out.println("accessToken = " + accessToken);
//        System.out.println("refreshToken = " + refreshToken);
//        //accessToken이 만료됐고 refreshToken이 맞으면 accessToken을 새로 발급(refreshToken의 내용을 통해서)
//        if (!jwtTokenProvider.isValidAccessToken(accessToken)) {  //클라이언트에서 토큰 재발급 api로의 요청을 확정해주면 이 조건문은 필요없다.
//            System.out.println("Access 토큰 만료됨");
//            if (jwtTokenProvider.isValidRefreshToken(refreshToken)) {     //들어온 Refresh 토큰이 유효한지
//                System.out.println("Refresh 토큰은 유효함");
//                Claims claimsToken = jwtTokenProvider.getClaimsToken(refreshToken);
//                Long userId = (long) (int) claimsToken.get("userId");
//                String tokenFromDB = memberRepository.findById(userId).orElseThrow(() -> new IllegalArgumentException("존재하지 않는 회원입니다.")).getRefreshToken();
//                System.out.println("tokenFromDB = " + tokenFromDB);
//                if (refreshToken.equals(tokenFromDB)) {   //DB의 refresh토큰과 지금들어온 토큰이 같은지 확인
//                    System.out.println("Access 토큰 재발급 완료");
//                    accessToken = jwtTokenProvider.createAccessToken(userId);
//                } else {
//                    //DB의 Refresh토큰과 들어온 Refresh토큰이 다르면 중간에 변조된 것임
//                    System.out.println("Refresh Token 탈취당했어 너 클났어");
//                    //예외발생
//                    throw new IllegalAccessException("잘못된 접근입니다.");
//                }
//            } else {
//                //입력으로 들어온 Refresh 토큰이 유효하지 않음
//                System.out.println("refresh token 유효하지 않아!");
//            }
//        }
//        return TokenResponse.builder()
//                .accessToken(accessToken)
//                .refreshToken(refreshToken)
//                .build();
//    }
//
//    public void logout(Long memberId) {
//        Member member = memberRepository.findById(memberId).get();
//        member.changeAutoLogin(false);
//        member.deleteRefreshToken();
//    }
//

//
//    public void modify(Long id, MemberModifyRequest memberModifyRequest) {
//        Member findMember = memberRepository.findById(id).get();
//        findMember.update(memberModifyRequest);
//    }
//
//    public void modifyPassword(Long id, String password) {
//        Member findMember = memberRepository.findById(id).get();
//        findMember.updatePassword(password);
//    }
//
//    public void modifySimplePassword(Long id, String simplePassword) {
//        Member findMember = memberRepository.findById(id).get();
//        findMember.updateSimplePassword(simplePassword);
//    }
//
//    public void deleteMember(Long id) {
//        Member findMember = memberRepository.findById(id).get();
//        memberRepository.delete(findMember);
//    }
//
//    public Boolean checkPassword(Long memberId, String password) {
//        Member member = memberRepository.findById(memberId).orElseThrow();
//        if (member.getPassword().equals(password)) {
//            return true;
//        } else return false;
//    }
//
//    public Boolean checkSimplePassword(Long memberId, String simplePassword) {
//        Member member = memberRepository.findById(memberId).orElseThrow();
//        if (member.getSimplePassword().equals(simplePassword)) {
//            return true;
//        } else return false;
//    }
//
//    public void addAccount(Long memberId, String account) {
//        Member member = memberRepository.findById(memberId).orElseThrow();
//        member.addAccount(account);
//    }
//
//
//    public Boolean checkAccessToken(HttpServletRequest request) {
//        String accessToken = jwtTokenProvider.resolveAccessToken(request);
//        Claims claimsToken = jwtTokenProvider.getClaimsFormToken(accessToken);
//        Long userId = (long) (int) claimsToken.get("userId");
//        System.out.println("검증 토큰 : " + accessToken + " 회원 아이디 : " + userId);
//        if (jwtTokenProvider.isValidAccessToken(accessToken)) { // accessToken이 유효하면
//            return true;//유효하면
//        }
//        return false;
//    }

}
