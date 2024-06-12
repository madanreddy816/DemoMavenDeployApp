# Use a Maven image to build the project
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and download the dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code into the container
COPY src ./src

# Package the application
RUN mvn package -DskipTests

# Use a Java image to run the application
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the packaged application from the build stage
COPY --from=build /Downloads/DemoMavenDeployApp/target/DemoMavenDeployApp-1.0-SNAPSHOT.jar /app/DemoMavenDeployApp.jar

# Expose the application port (if applicable)
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "DemoMavenDeployApp.jar"]
