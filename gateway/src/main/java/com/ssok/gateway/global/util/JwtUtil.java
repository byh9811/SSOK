package com.ssok.gateway.global.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import javax.annotation.PostConstruct;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtUtil {

    @Value("${secret.access}")
    private String SECRET_KEY;
    @Value("${secret.refresh}")
    private String REFRESH_KEY;
    // 객체 초기화, secretKey를 Base64로 인코딩한다.
    @PostConstruct
    protected void init() {
        System.out.println("SECRET_KEY: " + SECRET_KEY);
        System.out.println("REFRESH_KEY = " + REFRESH_KEY);
        SECRET_KEY = Base64.getEncoder().encodeToString(SECRET_KEY.getBytes());
        REFRESH_KEY = Base64.getEncoder().encodeToString(REFRESH_KEY.getBytes());
    }
    // Request의 Header에서 token 값을 가져옵니다. "X-AUTH-TOKEN" : "TOKEN값'
    public List<String> getToken(ServerHttpRequest request, String tokenName) {
        return request.getHeaders().get(tokenName);
    }

    public String getUUIDFromToken(String accessToken) {
        Claims claim = getClaimsFromAccessToken(accessToken);
        String memberUUId = (String)claim.get("memberUUID");
        return memberUUId;
    }
    public Claims getClaimsFromAccessToken(String token) {
        System.out.println("access-token : "+token);
        return Jwts.parser()
                .setSigningKey(SECRET_KEY.getBytes(StandardCharsets.UTF_8))
//                .setSigningKey(DatatypeConverter.parseBase64Binary(SECRET_KEY))
                .parseClaimsJws(token)
                .getBody();
    }

    public Claims getClaimsFromRefreshToken(String token) {
        return Jwts.parser()
                .setSigningKey(REFRESH_KEY.getBytes(StandardCharsets.UTF_8))
//                .setSigningKey(DatatypeConverter.parseBase64Binary(REFRESH_KEY))
                .parseClaimsJws(token)
                .getBody();
    }

    public boolean isValidAccessToken(String token) {
        System.out.println("isValidToken AccessToken is : " + token);
        try {
            Claims accessClaims = getClaimsFromAccessToken(token);
            System.out.println("Access expireTime: " + accessClaims.getExpiration());
            System.out.println("Access memberUUID: " + accessClaims.get("memberUUID"));
            return true;
        } catch (ExpiredJwtException exception) {
            System.out.println("Token Expired memberUUID : " + exception.getClaims().get("memberUUID"));
            return false;
        } catch (JwtException exception) {
            System.out.println("Token Tampered");
            return false;
        } catch (NullPointerException exception) {
            System.out.println("Token is null");
            return false;
        }
    }

    public Mono<Void> onError(ServerWebExchange exchange, String err, HttpStatus httpStatus){
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(httpStatus);
        log.error(err);
        return response.setComplete();
    }

    public boolean isValidRefreshToken(String token) {
        try {
            Claims accessClaims = getClaimsFromRefreshToken(token);
            System.out.println("Access expireTime: " + accessClaims.getExpiration());
            System.out.println("Access memberUUID: " + accessClaims.get("memberUUID"));
            return true;
        } catch (ExpiredJwtException exception) {
            System.out.println("Token Expired memberUUID : " + exception.getClaims().get("memberUUID"));
            return false;
        } catch (JwtException exception) {
            System.out.println("Token Tampered");
            return false;
        } catch (NullPointerException exception) {
            System.out.println("Token is null");
            return false;
        }
    }

    public boolean isOnlyExpiredToken(String token) {
        System.out.println("isValidToken is : " + token);
        try {
            Claims accessClaims = getClaimsFromAccessToken(token);
            System.out.println("Access expireTime: " + accessClaims.getExpiration());
            System.out.println("Access userId: " + accessClaims.get("userId"));
            return false;
        } catch (ExpiredJwtException exception) {
            System.out.println("Token Expired UserID : " + exception.getClaims().get("userId"));
            return true;
        } catch (JwtException exception) {
            System.out.println("Token Tampered");
            return false;
        } catch (NullPointerException exception) {
            System.out.println("Token is null");
            return false;
        }
    }

}
