# Stage 1: Build the application using a full Maven + Java image
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy only the pom.xml first to download dependencies (caching layer)
COPY pom.xml .
# Download dependencies (this makes subsequent builds faster if pom.xml hasn't changed)
RUN mvn dependency:go-offline -B

# Copy the actual source code
COPY src ./src

# Package the application (this compiles code and creates the .jar file)
# We skip tests here to speed up deployment builds
RUN mvn clean package -DskipTests

# Stage 2: Run the application using a lightweight Java JRE image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the built .jar file from the first stage
# The target file name depends on the artifactId and version in pom.xml
COPY --from=build /app/target/expense-tracker-*.jar app.jar

# Expose the standard Spring Boot port (also customizable via environment variables)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
