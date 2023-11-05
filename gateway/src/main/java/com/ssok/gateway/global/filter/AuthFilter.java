package com.ssok.gateway.global.filter;

import com.ssok.gateway.global.util.JwtUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
public class AuthFilter extends AbstractGatewayFilterFactory<AuthFilter.Config> {
    private final JwtUtil jwtUtil;

    @Autowired
    public AuthFilter(JwtUtil jwtUtil) {
        super(AuthFilter.Config.class);
        this.jwtUtil = jwtUtil;
    }

    public static class Config {
        //config
    }

    /*토큰 검증 필터*/
    @Override
    public GatewayFilter apply(AuthFilter.Config config) {
        return (exchange, chain) -> {
            //ServerHttpRequest
            ServerHttpRequest request = exchange.getRequest();

            List<String> accessToken = jwtUtil.getToken(request, "ACCESS-TOKEN");
            List<String> refreshToken = jwtUtil.getToken(request, "REFRESH-TOKEN");


            if (accessToken != null && jwtUtil.isValidAccessToken(accessToken.get(0))) {
                request.mutate().header("AUTH", "true").build();
                request.mutate().header("MEMBER-UUID", jwtUtil.getUUIDFromToken(accessToken.get(0))).build();
                return chain.filter(exchange);
            }

            request.mutate().header("AUTH", "false").build();
            return chain.filter(exchange);
        };
    }
}
