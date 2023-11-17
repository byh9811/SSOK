# 버전 설정

```bash
Ubuntu: 20.04
Java: 17
Spring : 2.7.14
Dart : 3.1.3
Flutter : 3.13.6
Jenkins : 2.429
MariaDB : 15.1
MongoDB : 4.4.25
Redis : 7.2.3
Docker : 24.0.7
```

# 포트 설정

```bash
Jenkins: 8080:8080
Backend-service : 8081:8081
FE/Intro : 3000:3000
FE/Pos : 3030:3000
Prometheus : 9090:9090
Grafana: 3000:3000
Config: 61070:61070
Discovery : 8761:8761
Gateway : 9000:9000
Virtual : 61072:61072
Redis: 6379:6379
MariaDB: 3306:3306
Mongo: 27017:27017
```

# 서버 구축

- 인스턴스 생성 (AWS, OCI, GCP)
    - AWS
        - 싸피 제공 Lightsail
    - GCP
        - 리전: asia-northeast3 (서울)
        - 영역: asia-northeast3-a
        - 머신: E2
        - 부팅디스크: 표준 영구 디스크 30GB
        - GCP 방화벽: HTTP, HTTPS (+ 외부에서 DB 접속하려면 3306, 27017 추가로) 허용
        - IP 주소 - 고정 IP 발급 후 인스턴스에 연결
        - 메타데이터 - 다른 컴퓨터에서 키 페어 생성 후 공개키 등록
        - putty나 mobaXTerm에 개인키를 등록하여 접속
    - OCI
        - 리전 : asia-chuncheon
        - 부팅 디스크 : 표준 영구 디스크
- Domain Name 구매 후 IP 주소에 연동 (가비아)
- Nginx 설치
- SSL 인증서 발급 (Certbot)
- 방화벽 22, 80, 443 허용
- 도커 패키지 설치
- 젠킨스 도커 이미지 pull, 컨테이너 실행
    - Gitlab Webhook, Credential, 계정 Credential 등록
    - Docker Hub Credential 등록
    - Ubuntu 설정 등록
    - Item 등록, Script 작성
- MariaDB 설치
- MongoDB 설치

# Dockerfile

Backend

```bash
FROM openjdk:17-oracle

ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} /app.jar

ARG ssh_encrypt_key
ENV ssh-encrypt-key $ssh_encrypt_key

ENTRYPOINT ["java", "-jar","-Dspring.cloud.config.profile=dev", "/app.jar"]
```

Frontend

```bash
FROM node:18

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

# Service yml

1. Config 파일 관리용 Github Repository 생성
2. Private Repository Access Token 생성
3. 각 서비스 application name에 맞는 브랜치 생성 후 config 폴더 생성
4. Config 서버 Nginx 설정에 `/config`에 대한 요청 처리

    ```jsx
    location /config {
    	proxy_pass http://localhost:61070;
    }
    ```

5. 다음 yml 파일들에 키 값 등 누락된 값을 추가한 후 자신의 서비스 이름 브랜치 config 폴더 안에 application.yml, application-dev.yml, application-local.yml 등 목적에 맞게 생성

### Config

```bash
server:
  port: 61070

spring:
  cloud:
    config:
      server:
        git:
          uri: git@github.com:byh9811/config_example.git
          default-label: main
          ignore-local-ssh-settings: true
          private-key: |
            -----BEGIN EC PRIVATE KEY-----
						Private Repository Access Token 
            -----END EC PRIVATE KEY-----
          host-key: AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
          host-key-algorithm: ecdsa-sha2-nistp256
          search-paths: "{application}"
        encrypt:
          enabled: false

# actuator ??
management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    shutdown:
      enabled: true

encrypt:
  key: ${ssh-encrypt-key}
```

### Discovery

```bash
server:
  port: 8761

spring:
  application:
    name: discovery
    
eureka:
  client:
    register-with-eureka: false
    fetch-registry: false
```

### gateway

```bash
server:
  port: 9000

spring:
  application:
    name: gateway
  cloud:
    gateway:
      routes:
        - id: member-service
          predicates:
            - Path=/api/member-service/**
          uri : https://member.ssok.site
          filters :
        - id: namecard-service
          predicates:
            - Path=/api/namecard-service/**
          uri : https://namecard.ssok.site
          filters:
            - AuthPermissionFilter
        - id: pocket-service
          predicates:
            - Path=/api/pocket-service/**
          uri : https://pocket.ssok.site
          filters:
            - AuthPermissionFilter
        - id: receipt-service
          predicates:
            - Path=/api/receipt-service/**
          uri : https://receipt.ssok.site
          filters:
            - AuthPermissionFilter
        - id: idcard-service
          predicates:
            - Path=/api/idcard-service/**
          uri : https://idcard.ssok.site
          filters:
            - AuthPermissionFilter

          
eureka:
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: https://discovery.ssok.site/eureka
secret:
  access:
  refresh:
```

### idcard

```bash
server:
  port: 8081

spring:
  application:
    name: idcard-service
  datasource:
    driver-class-name: org.mariadb.jdbc.Driver
    url: 
    username: 
    password: 
    hikari:
        maximumPoolSize: 1
  jpa:
    hibernate: # hibernate 사용 설정
      ddl-auto: create
    properties: # property 사용 설정
      hibernate: # hibernate property 설정
        format_sql: true # To beautify or pretty print the SQL
        show_sql: true # show sql
  servlet:
    multipart:
      maxFileSize: 10MB # 파일 하나의 최대 크기
      maxRequestSize: 30MB # 한 번에 최대 업로드 가능 용량
  cloud:
    gcp:
      storage:
        credentials:
          encoded-key: 
        project-id: virtual-airport-403203
        bucket: ssok-bucket

jwt:
  access:
    key: 
    valid-time: "7776000000"    # 90일
  refresh:
    key: 
    valid-time: "31536000000"    # 365일

logging:
  level:
    org.hibernate:
      type.descriptor.sql: trace # show parameter binding
      SQL: DEBUG

eureka:
  instance:
    prefer-ip-address: true
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: https://discovery.ssok.site/eureka

ocr:
  idcard:
    url: 
    key: 
  namecard:
    url: 
    key: 

management:
  endpoints:
    web:
      exposure:
        include: health, info, prometheus
```

### member

```bash
server:
  port: 8081

eureka:
  instance:
    prefer-ip-address: true
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: https://discovery.ssok.site/eureka

spring:
  application:
    name: member-service
  datasource:
    driver-class-name: org.mariadb.jdbc.Driver
    url: 
    username: 
    password: 
    hikari:
        maximumPoolSize: 1
  jpa:
    hibernate: # hibernate 사용 설정
      ddl-auto: create
    properties: # property 사용 설정
      hibernate: # hibernate property 설정
        format_sql: true # To beautify or pretty print the SQL
        show_sql: true # show sql
  data:
    mongodb:
      uri: 

  servlet:
    multipart:
      maxFileSize: 10MB # 파일 하나의 최대 크기
      maxRequestSize: 30MB # 한 번에 최대 업로드 가능 용량
  
  redis:
    host: redis
    port: 6379

logging:
  level:
    org.hibernate:
      type.descriptor.sql: trace # show parameter binding
      SQL: DEBUG

naver-cloud-sms:
  accessKey: 
  secretKey: 
  serviceId: 
  senderPhone: 
  
secret:
  access: 
  refresh:
  
management:
  endpoints:
    web:
      exposure:
        include: health, info, prometheus
```

### namecard

```bash
server:
  port: 8081

eureka:
  instance:
    prefer-ip-address: true
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: https://discovery.ssok.site/eureka

spring:
  application:
    name: namecard-service
  datasource:
    driver-class-name: org.mariadb.jdbc.Driver
    url: jdbc:
    username: 
    password: 
    hikari:
      maximumPoolSize: 1
  jpa:
    hibernate: # hibernate 사용 설정
      ddl-auto: none
    properties: # property 사용 설정
      hibernate: # hibernate property 설정
        format_sql: true # To beautify or pretty print the SQL
        show_sql: true # show sql
  data:
    mongodb:
      uri: 
  servlet:
    multipart:
      maxFileSize: 10MB # 파일 하나의 최대 크기
      maxRequestSize: 30MB # 한 번에 최대 업로드 가능 용량

  cloud:
    gcp:
      storage:
        credentials:
          encoded-key: 
        project-id: 
        bucket: 

logging:
  level:
    org.hibernate:
      type.descriptor.sql: trace # show parameter binding
      SQL: DEBUG

management:
  endpoints:
    web:
      exposure:
        include: health, info, prometheus
```

### pocket

```bash
server:
  port: 8081

eureka:
  instance:
    prefer-ip-address: true
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: https://discovery.ssok.site/eureka

spring:
  application:
    name: pocket-service
  jackson:
    time-zone: Asia/Seoul

  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url:
    username: 
    password: 
  jpa:
    hibernate: # hibernate 사용 설정
      ddl-auto: create
    properties: # property 사용 설정
      hibernate: # hibernate property 설정
        format_sql: true # To beautify or pretty print the SQL
        show_sql: true # show sql
  data:
    mongodb:
      uri: 
  servlet:
    multipart:
      maxFileSize: 10MB # 파일 하나의 최대 크기
      maxRequestSize: 30MB # 한 번에 최대 업로드 가능 용량

management:
  endpoints:
    web:
      exposure:
        include: health, info, prometheus

logging:
  level:
    org.hibernate:
      type.descriptor.sql: trace # show parameter binding
      SQL: DEBUG
```

### receipt

```bash
server:
  port: 8081

spring:
  application:
    name: receipt-service
  datasource:
    driver-class-name: org.mariadb.jdbc.Driver
    url:
    username: 
    password: 
    hikari:
        maximumPoolSize: 1
  jpa:
    hibernate: # hibernate 사용 설정
      ddl-auto: create
    properties: # property 사용 설정
      hibernate: # hibernate property 설정
        format_sql: true # To beautify or pretty print the SQL
        show_sql: true # show sql
  data:
    mongodb:
      uri:
  servlet:
    multipart:
      maxFileSize: 10MB # 파일 하나의 최대 크기
      maxRequestSize: 30MB # 한 번에 최대 업로드 가능 용량

logging:
  level:
    org.hibernate:
      type.descriptor.sql: trace # show parameter binding
      SQL: DEBUG

eureka:
  instance:
    prefer-ip-address: true
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: https://discovery.ssok.site/eureka

management:
  endpoints:
    web:
      exposure:
        include: health, info, prometheus
```

### virtual

```bash
server:
  port: 61072
  
spring:
  datasource:
    driver-class-name: org.mariadb.jdbc.Driver
    url:
    username: 
    password: 
    hikari:
      maximumPoolSize: 3
  mvc:
    pathmatch:
      matching-strategy: ant_path_matcher
      
jwt:
  access:
    key: 
    valid-time: "7776000000"    # 90일
  refresh:
    key: 
    valid-time: "31536000000"    # 365일

management:
  endpoints:
    web:
      exposure:
        include: health, info, prometheus
```

# Jenkins pipeline Script

```bash
pipeline {
    agent any
    
    options {
        timeout(time: 10, unit: 'MINUTES')
    }
    
    environment {
        imageName = "도커허브레포/이미지이름"
        registryCredential = '깃렙credential'
        dockerImage = '도커이미지 이름'
        dockerContainer = "도커 컨테이너 이름"
        dockerCredential = "도커 허브 Credential"
        releaseServerAccount = 'ubuntu 서버 계정'
        releaseServerUri = '서버 Url'
				projectName = '프로젝트 폴더'
        releasePort = '실행 포트'
    }

    stages {
        stage('Git Clone') {
            steps {
                git branch: '해당 브랜치', credentialsId: '깃랩 credential', url: '깃렙 레포 주소'
            }
        }
        stage('Gradle Build') {
            steps {
                dir ('프로젝트 폴더') {
                    sh 'chmod +x gradlew'
                    sh './gradlew clean bootJar'
                }
            }
            post {
                failure {
                    error 'Fail Build'
                }
            }
        }
        stage('Image Build'){
            steps{
                sh 'docker build -t ${imageName} --build-arg ssh_encrypt_key=암호화키./${projectName}'
            }
        }
        stage('Docker Image Push') {
            steps {
                withDockerRegistry([ credentialsId: "${dockerCredential}", url: "" ]) {
                    sh 'docker push ${imageName}'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    def containersToStop = sh(script: "docker ps -q --filter name=${dockerContainer}", returnStdout: true).trim()
                    if (containersToStop) {
                        containersToStop.split('\n').each { containerId ->
                            sh(script: "docker stop $containerId", returnStatus: true)
                        }
                    }
                    sh 'docker image prune -f'
                    sh 'docker run --rm -d -p ${releasePort}:${releasePort} --name ${dockerContainer} ${imageName} sleep infinity'
                }
            }
        }
    }
}
```

# Redis

```bash
sudo docker pull redis
docker run -d -p 6379:6379 --name redis redis
```

# Prometheus

- 각 서비스 actuator 의존성 추가, yml 내용 추가

    ```bash
    management:
      endpoints:
        web:
          exposure:
            include: health, info, prometheus
    ```

- docker image pull & run

    ```bash
    sudo docker pull prom/prometheus
    
    docker run -p 9090:9090 -v {%상위경로%}/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
    ```

    - 자신의 서버에 Prometheus.yml 작성 후 해당 경로 작성

# Prometheus.yml

```bash
global:
  scrape_interval: 10s
 
scrape_configs:
  - job_name: '서비스 이름'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: [서비스 도메인:포트]
	-...
```

# Grafana

```bash
docker pull grafana/grafana

docker run --name grafana -d -p 3000:3000 grafana/grafana
```

- 접속 후 Prometheus 데이터 소스 생성
- url : http://host.docker.internal:9090/
- 대쉬 보드 : https://grafana.com/grafana/dashboards/4701