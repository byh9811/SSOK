package com.ssok.base.domain.api;

import com.ssok.base.RestDocsSupport;
import com.ssok.base.domain.api.dto.request.DomainJoinRequest;
import com.ssok.base.domain.api.dto.response.DomainJoinResponse;
//import com.ssok.base.domain.service.PocketQueryService;
import com.ssok.base.domain.service.PocketService;
import com.ssok.base.domain.service.dto.DomainDto;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.restdocs.payload.JsonFieldType;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;
import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.document;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.get;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.post;
import static org.springframework.restdocs.operation.preprocess.Preprocessors.*;
import static org.springframework.restdocs.payload.PayloadDocumentation.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

public class DomainControllerDocsTest extends RestDocsSupport {

    private final PocketService pocketService = mock(PocketService.class);
//    private final PocketQueryService pocketQueryService = mock(PocketQueryService.class);

    @Override
    protected Object initController() {
//        return new PocketController(pocketService, pocketQueryService);
        return new PocketController(pocketService);
    }

    @Test
    @DisplayName("도메인을 등록합니다.")
    void joinDomain() throws Exception {
        DomainJoinRequest request = DomainJoinRequest.builder()
                .nickname("name")
                .age(10)
                .build();

        given(pocketService.createDomain(any(DomainDto.class)))
                .willReturn(DomainJoinResponse.builder()
                        .nickname("name")
                        .age(20)
                        .build()
                );

        mockMvc.perform(
                        post("/pocket")
                                .content(objectMapper.writeValueAsString(request))
                                .contentType(MediaType.APPLICATION_JSON)
                )
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("domain-create",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        requestFields(
                                fieldWithPath("nickname").type(JsonFieldType.STRING).description("닉네임"),
                                fieldWithPath("age").type(JsonFieldType.NUMBER).description("나이")
                        ),
                        responseFields(
                                fieldWithPath("success").type(JsonFieldType.BOOLEAN).description("성공여부"),
                                fieldWithPath("response").type(JsonFieldType.OBJECT).optional().description("응답 객체"),
                                fieldWithPath("response.nickname").type(JsonFieldType.STRING).description("닉네임"),
                                fieldWithPath("response.age").type(JsonFieldType.NUMBER).description("나이"),
                                fieldWithPath("error").type(JsonFieldType.OBJECT).optional().description("에러 객체")
                        )
                        ));
    }

    @Test
    @DisplayName("도메인을 조회합니다.")
    void getDomain() throws Exception {
        DomainJoinRequest request = DomainJoinRequest.builder()
                .nickname("name")
                .age(10)
                .build();

        given(pocketService.createDomain(any(DomainDto.class)))
                .willReturn(DomainJoinResponse.builder()
                        .nickname("name")
                        .age(20)
                        .build()
                );

        mockMvc.perform(
                        get("/pocket")
                                .content(objectMapper.writeValueAsString(request))
                                .contentType(MediaType.APPLICATION_JSON)
                )
                .andDo(print())
                .andExpect(status().isOk())
                .andDo(document("domain-get",
                        preprocessRequest(prettyPrint()),
                        preprocessResponse(prettyPrint()),
                        requestFields(
                                fieldWithPath("nickname").type(JsonFieldType.STRING).description("닉네임"),
                                fieldWithPath("age").type(JsonFieldType.NUMBER).description("나이")
                        ),
                        responseFields(
                                fieldWithPath("success").type(JsonFieldType.BOOLEAN).description("성공여부"),
                                fieldWithPath("response").type(JsonFieldType.OBJECT).optional().description("응답 객체"),
                                fieldWithPath("response.nickname").type(JsonFieldType.STRING).description("닉네임"),
                                fieldWithPath("response.age").type(JsonFieldType.NUMBER).description("나이"),
                                fieldWithPath("error").type(JsonFieldType.OBJECT).optional().description("에러 객체")
                        )
                ));
    }

}
