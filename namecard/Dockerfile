# gredle 이미지 불러오기
FROM openjdk:17-oracle

# jar 파일을 Docker Container의 WORKDIR 위치로 복사 (이미지 생성할 때 동작)
#WORKDIR /config
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} /app.jar

# 환경변수 설정
ARG ssh_encrypt_key
ENV ssh-encrypt-key $ssh_encrypt_key

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENTRYPOINT ["java", "-jar","-Dspring.cloud.config.profile=dev", "/app.jar"]