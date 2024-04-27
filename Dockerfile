FROM maven:3.9.6-amazoncorretto-21 as builder
MAINTAINER ghencon.com
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
WORKDIR /app

COPY . .
COPY .subjects ~/.subjects

RUN mvn clean install

FROM azul/zulu-openjdk-alpine:21-jre

WORKDIR /app

RUN mkdir -p ~/.subjects
RUN mkdir -p ~/.subjects/st-icc-352/
RUN mkdir -p ~/.subjects/st-icc-354/

COPY --from=builder /app/target/*.jar /app/app.jar

COPY --from=builder /app/.subjects ~/.subjects

ENTRYPOINT ["java", "-jar", "app.jar"]
