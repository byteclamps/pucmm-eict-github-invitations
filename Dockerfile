FROM maven:3.9.6-amazoncorretto-21 as builder
MAINTAINER ghencon.com
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
WORKDIR /app

COPY . .

RUN mvn clean install -Dmaven.test.skip=true

FROM azul/zulu-openjdk-alpine:21-jre

WORKDIR /app

COPY --from=builder /app/target/*.jar /app/app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
