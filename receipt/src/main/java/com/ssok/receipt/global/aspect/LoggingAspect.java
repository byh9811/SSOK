package com.ssok.receipt.global.aspect;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;

import java.util.Arrays;

@Component
@Aspect
@Slf4j
public class LoggingAspect {

	/**
	 * 도메인 관련 메서드 수행 시간이 얼마나 소요되는지 기록하는 로그
	 * */
	@Around(value = "execution(* com.ssok.receipt.domain..*(..))")
	public Object loggingExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
		log.debug("Entered Method ({}) With Parameter ({})", joinPoint.getSignature().toShortString(), Arrays.toString(joinPoint.getArgs()));

		StopWatch stopWatch = new StopWatch();
		stopWatch.start();
		Object proceed = joinPoint.proceed();
		stopWatch.stop();

		log.debug("Executed Method ({}) in ({}) ms", joinPoint.getSignature().toShortString(), stopWatch.getTotalTimeMillis());
		return proceed;
	}

}