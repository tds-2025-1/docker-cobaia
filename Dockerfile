FROM gradle:8.5-jdk17-alpine AS build

WORKDIR /app

# Only copy what's needed to optimize build caching
COPY build.gradle .
COPY settings.gradle .
COPY gradle ./gradle
COPY src ./src

# Run Gradle build (skip tests if you prefer)
RUN gradle build -x test --no-daemon

# Stage 2: Create slim runtime image
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the fat jar (adjust if your jar name changes)
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
