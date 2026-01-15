# Stage 1: build jar artifact with maven
FROM maven:3.9.5-eclipse-temurin-17 AS build

WORKDIR /myapp
COPY pom.xml .

RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests


# Stage 2: runtime
FROM eclipse-temurin:17-jre-alpine

RUN addgroup -S privUsers && adduser -S yaara -G privUsers
USER yaara

WORKDIR /myapp

COPY --from=build /myapp/target/myapp-*.jar ./myapp.jar

CMD ["java", "-jar", "myapp.jar"]
