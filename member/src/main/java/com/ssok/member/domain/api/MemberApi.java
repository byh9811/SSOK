package com.ssok.member.domain.api;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ssok.member.domain.api.dto.request.*;
import com.ssok.member.domain.api.dto.response.MemberAccountResponse;
import com.ssok.member.domain.api.dto.response.MemberSeqResponse;
import com.ssok.member.domain.api.dto.response.TokenResponse;
import com.ssok.member.domain.service.dto.*;
import com.ssok.member.global.api.ApiResponse;
import com.ssok.member.domain.api.dto.response.SmsResponse;
import com.ssok.member.domain.service.MemberQService;
import com.ssok.member.domain.service.MemberService;
import com.ssok.member.domain.service.SmsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import static com.ssok.member.global.api.ApiResponse.OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/member-service")
@Slf4j
public class MemberApi {

    private final SmsService smsService;
    private final MemberService memberService;
    private final MemberQService memberQService;

    //test
    @GetMapping("/service")
    public String springCloudService() {
        System.out.println("test");
        return "spring-cloud-service 호출!";
    }
    //회원 UUID 조회
    @GetMapping("/temp")
    public ApiResponse<String> temp(@RequestParam(name="refresh-token") String refreshToken) {
        String uuid = memberService.getUuid(refreshToken);
        return OK(uuid);
    }

    //회원 Seq 조회
    @GetMapping("/member/seq")
    public ApiResponse<Long> getMemberSeq(@RequestParam (name = "member-uuid")String memberUuid){
        System.out.println(memberUuid);
        log.info(memberUuid);
        Long memberSeq = memberService.getSeq(memberUuid);
        return OK(memberSeq);
    }
    // 연동 계좌번호 조회
    @GetMapping("/member/account")
    public ApiResponse<String> getMemberAccount(@RequestParam (name = "member-seq")Long memberSeq){
        String memberAccount = memberService.getAccount(memberSeq);
        return OK(memberAccount);
    }
    // 연동 계좌번호 변경
    @PostMapping("/member/account")
    public ApiResponse<String> editMemberAccount(@RequestBody MemberAccountUpdateRequest memberAccountUpdateRequest){
        MemberAccountResponse memberAccountResponse = memberService.editAccountNum(MemberAccountUpdateDto.of(memberAccountUpdateRequest));
        return OK(memberAccountResponse.getMemberAccountNum());
    }
    //마이데이터 접근 토큰 조회
    @GetMapping("/member/mydata")
    public ApiResponse<String> getMydataAccessToken(@RequestParam (name = "member-seq")Long memberSeq){
        String memberMydataAccessToken = memberService.getMydataAccessToken(memberSeq);
        return OK(memberMydataAccessToken);
    }
    //마이데이터 접근 토큰 변경
    @PostMapping("/member/mydata")
    public ApiResponse<String> editMydataAccessToken(@RequestBody MemberMydataAccessTokenUpdateRequest memberMydataAccessTokenUpdateRequest){
        String memberMydataAccessToken = memberService.editMydataAccessToken(MemberMydataAccessTokenUpdateDto.of(memberMydataAccessTokenUpdateRequest));
        return OK(memberMydataAccessToken);
    }
    //잔금 저금 여부 조회
    @GetMapping("/member/saving")
    public ApiResponse<Boolean> getSaving(@RequestParam (name = "member-seq")Long memberSeq){
        Boolean isSaving =memberService.getSaving(memberSeq);
        return OK(isSaving);
    }
    //잔금 저금 여부 변경
    @PostMapping("/member/saving")
    public ApiResponse<Boolean> editSaving(@RequestParam (name = "member-seq")Long memberSeq){
        Boolean saving = memberService.editSaving(memberSeq);
        return OK(saving);
    }
    //신분 인증 여부 조회
    @GetMapping("/member/verification")
    public ApiResponse<Boolean> getIsVerification(@RequestParam (name = "member-seq")Long memberSeq){
        Boolean verification = memberService.getVerification(memberSeq);
        return OK(verification);
    }
    //신분 인증 여부 변경
    @PostMapping("/member/verification")
    public ApiResponse<Boolean> editIsVerification(@RequestParam (name = "member-seq")Long memberSeq){
        Boolean verification = memberService.editVerification(memberSeq);
        return OK(verification);
    }
    //회원 CI 조회
    @GetMapping("/member/ci")
    public ApiResponse<String> getCi(@RequestParam (name = "member-seq")Long memberSeq){
        String memberCi = memberService.getCi(memberSeq);
        return OK(memberCi);
    }
    //회원 이름 조회
    @GetMapping("/member/name")
    public ApiResponse<String> getName(@RequestParam (name = "member-seq")Long memberSeq){
        String memberName = memberService.getName(memberSeq);
        return OK(memberName);
    }
//    @PostMapping("/member/seq")
//    public ApiResponse<MemberSeqResponse> getMemberSeq(@RequestBody String memberUuid){
//        System.out.println("memberUuid");
//        log.info(memberUuid);
//        MemberSeqResponse memberSeqResponse = memberService.getUuid(memberUuid);
//        return OK(memberSeqResponse);
//    }

    //인증번호 발송
    @PostMapping("/sms/send")
    public ApiResponse<SmsResponse> sendSms(@RequestBody MessageRequest messageRequest) throws UnsupportedEncodingException, URISyntaxException, NoSuchAlgorithmException, InvalidKeyException, JsonProcessingException {
        log.info(messageRequest.getTo());
        SmsResponse smsResponse = smsService.sendSms(messageRequest);
        return OK(smsResponse);
    }
    //인증 번호 검증
    @PostMapping("/sms/check")
    public ApiResponse<Boolean> verifySMS(@RequestBody VerifySmsRequest verifySmsRequest) throws ChangeSetPersister.NotFoundException, UnsupportedEncodingException, URISyntaxException, NoSuchAlgorithmException, InvalidKeyException, JsonProcessingException {
        Boolean check = smsService.verifySms(verifySmsRequest);
        return OK(check);
    }

    // 회원가입 아이디 중복 검사
    @GetMapping("/member/check")
    public ApiResponse<Boolean> checkId(@RequestParam("id") String loginId) {
        Boolean check = memberService.checkId(loginId);
        return OK(check);
    }

    // 회원가입
    @PostMapping("/member/create")
    public ApiResponse<Boolean> createMember(@RequestBody MemberCreateRequest memberCreateRequest) {
        memberService.save(MemberCreateDto.of(memberCreateRequest));
        return OK(null);
    }
    //로그인
    @PostMapping("/member/login")
    public ApiResponse<TokenResponse> login(@RequestBody MemberLoginRequest memberLoginRequest){
        TokenResponse tokenResponse = memberService.login(MemberLoginDto.of(memberLoginRequest));
        return OK(tokenResponse);
    }

    //약관 동의
    @PostMapping("/member/agreement")
    public ApiResponse<?> agreement(@RequestBody String loginId){
        memberService.editAgreement(loginId);
        return OK(null);
    }

    //간편 비밀번호
    @PostMapping("/member/simplepassword")
    public ApiResponse<Boolean> checkSimplePassword(@RequestBody MemberSimplePasswordCheckRequest memberSimplePasswordCheckRequest){
        boolean checkSimplePassword = memberService.checkSimplePassword(MemberSimplePasswordCheckDto.of(memberSimplePasswordCheckRequest));
        return OK(checkSimplePassword);
    }

//    // 비밀번호 검사
//    @PostMapping("/password/check")
//    public ApiResponse<Boolean> verifyPassword(@AuthenticationPrincipal User user, @RequestBody VerifyPasswordRequest verifyPasswordRequest) {
//        Long memberId = Long.parseLong(user.getUsername());
//        Boolean check = memberService.checkPassword(memberId, verifyPasswordRequest.getPassword());
//        return OK(check);
//    }
//

//
//    @ApiOperation(value = "간편 로그인", notes = "간편 비밀번호 입력하고 로그인을 진행하는 API")
//    @PostMapping("/simple-login")
//    public ApiResponse<TokenResponse> simpleLogin(HttpServletRequest request, @RequestBody SimpleLoginRequest simpleLoginRequest) {
//        TokenResponse tokenResponse = memberService.simpleLogin(request, simpleLoginRequest);
//        return OK(tokenResponse);
//    }
//
//    @ApiOperation(value = "access token 재발급", notes = "accesstoken 재발급을 진행하는 API")
//    @PostMapping("/issue")
//    public ApiResponse<TokenResponse> issueToken(HttpServletRequest request) throws IllegalAccessException {
//        TokenResponse tokenResponse = memberService.issueAccessToken(request);
//        return OK(tokenResponse);
//    }
//
//    @ApiOperation(value = "token 유효성 검사", notes = "refreshtoken 유효성 검사 API")
//    @PostMapping("/check/token")
//    public ApiResponse<Boolean> checkToken(HttpServletRequest request) {
//        Boolean check = memberService.checkToken(request);
//        return OK(check);
//    }
//
//    @ApiOperation(value = "access-token 유효성 검사", notes = "accessToken 유효성 검사 API")
//    @PostMapping("/check/access-token")
//    public ApiResponse<Boolean> checkAccessToken(HttpServletRequest request) {
//        Boolean check = memberService.checkAccessToken(request);
//        return OK(check);
//    }
//
    @PostMapping("/logout")
    public ApiResponse<Void> logout(HttpServletRequest httpServletRequest, @RequestBody String memberId ) {
        HttpSession session = httpServletRequest.getSession();
        session.invalidate();
        System.out.println(memberId);
        memberService.logout(memberId);
        return OK(null);
    }
//
//    @ApiOperation(value = "회원 정보 조회", notes = "회원 정보를 조회하는 API")
//    @GetMapping("/info")
//    public ApiResponse<MemberInfoResponse> getMemberInfoById(@AuthenticationPrincipal User user) {
//        Long memberId = Long.parseLong(user.getUsername());
//        MemberInfoResponse memberInfoResponse = memberQService.findById(memberId);
//        return OK(memberInfoResponse);
//    }
//
//    @ApiOperation(value = "회원 정보 수정", notes = "회원 정보를 수정하는 API")
//    @PutMapping("/info")
//    public ApiResponse<?> modifyMemberInfoById(@AuthenticationPrincipal User user, @RequestBody MemberModifyRequest memberModifyRequest) {
//        Long memberId = Long.parseLong(user.getUsername());
//        memberService.modify(memberId, memberModifyRequest);
//        return OK(null);
//    }
//
//    @ApiOperation(value = "회원 비밀번호 수정", notes = "회원 비밀번호를 수정하는 API")
//    @PutMapping("/password")
//    public ApiResponse<?> modifyPasswordById(@AuthenticationPrincipal User user, @RequestBody Map<String, String> body) {
//        String password = body.get("password");
//        log.info(password);
//        Long memberId = Long.parseLong(user.getUsername());
//        memberService.modifyPassword(memberId, password);
//        return OK(null);
//    }
//
//    @ApiOperation(value = "회원 간편 비밀번호 수정", notes = "회원 간편 비밀번호를 수정하는 API")
//    @PutMapping("/simple-password")
//    public ApiResponse<?> modifySimplePasswordById(@AuthenticationPrincipal User user, @RequestBody Map<String, String> body) {
//        Long memberId = Long.parseLong(user.getUsername());
//        String simplePassword = body.get("simplePassword");
//        memberService.modifySimplePassword(memberId, simplePassword);
//        return OK(null);
//    }
//
//    @ApiOperation(value = "회원 탈퇴", notes = "회원 탈퇴 API")
//    @DeleteMapping()
//    public ApiResponse<ResultResponse> deleteMemberById(@AuthenticationPrincipal User user) {
//        Long memberId = Long.parseLong(user.getUsername());
//        memberService.deleteMember(memberId);
//        return OK(null);
//    }
//
//    @ApiOperation(value = "계좌 등록", notes = "회원 탈퇴 API")
//    @PostMapping("/account")
//    public ApiResponse<?> addAccount(@AuthenticationPrincipal User user, @RequestBody Map<String, String> body) {
//        Long memberId = Long.parseLong(user.getUsername());
//        String account = body.get("account");
//        memberService.addAccount(memberId, account);
//        return OK(null);
//    }


}
