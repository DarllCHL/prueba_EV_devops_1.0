# ---- Stage 1: Build ----
FROM eclipse-temurin:17-jdk-alpine AS buildstage

RUN apk add --no-cache maven

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
COPY Wallet_N72BZHZWYZGTE7OH ./wallet

ENV TNS_ADMIN=/app/wallet

RUN mvn clean package -DskipTests

# ---- Stage 2: Runtime ----
FROM eclipse-temurin:17-jre-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=buildstage /app/target/bdget-0.0.1-SNAPSHOT.jar ./bdget.jar
COPY --from=buildstage /app/wallet ./wallet

ENV TNS_ADMIN=/app/wallet

RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/bdget.jar"]