package com.ssok.namecard.domain.api;

import static com.ssok.namecard.global.api.ApiResponse.OK;

import com.ssok.namecard.domain.service.NamecardQueryService;
import com.ssok.namecard.domain.service.NamecardService;
import com.ssok.namecard.domain.service.dto.NamecardCreateRequest;
import com.ssok.namecard.global.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/namecard")
public class NamecardController {

    private final NamecardService namecardService;
    private final NamecardQueryService namecardQueryService;

    /** 명함 등록 */
    @PostMapping("/")
    public ApiResponse<Void> createNamecardRequest(
        @RequestBody NamecardCreateRequest namecardCreateRequest,
        @RequestHeader String memberId
    ){
        namecardService.createNamecard(namecardCreateRequest, memberId);
        return OK(null);
    }

    /* example

    @PostMapping
    public ApiResponse<DomainJoinResponse> createDomain(
            @RequestBody DomainJoinRequest domainJoinRequest
    ) {
        return OK(new DomainJoinResponse("dummy", 20));
    }

    @GetMapping
    public ApiResponse<DomainJoinResponse> getDomain(
            @RequestBody DomainJoinRequest domainJoinRequest
    ) {
        return OK(new DomainJoinResponse("dummy", 20));
    }

    */

}
