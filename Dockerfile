FROM maven:3.9.6-amazoncorretto-21 as builder
MAINTAINER ghencon.com
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
WORKDIR /app

COPY . .

RUN mvn clean install

FROM azul/zulu-openjdk-alpine:21-jre

WORKDIR /app

RUN mkdir -p ~/.subjects
RUN mkdir -p ~/.subjects/st-icc-352/
RUN mkdir -p ~/.subjects/st-icc-354/

COPY --from=builder /app/target/*.jar /app/app.jar

COPY --from=builder /app/.valid-emails-352 /root/.subjects/st-icc-352/.valid-emails
COPY --from=builder /app/.valid-emails-354 /root/.subjects/st-icc-354/.valid-emails

ENTRYPOINT ["java", "-jar", "app.jar"]
