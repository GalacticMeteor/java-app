# Build stage
FROM maven:3.8.4-openjdk-11 as build

WORKDIR /app

# Copy parent POM
COPY pom.xml .

# Copy only webapp POM
COPY webapp/pom.xml ./webapp/

# Download dependencies (cached layer if pom.xml files don't change)
RUN mvn dependency:go-offline -B

# Copy webapp source code
COPY webapp/src ./webapp/src

# Build the application
RUN mvn clean package -B

# Runtime stage
FROM tomcat:9-jdk11-openjdk-slim

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Remove default webapps and copy our WAR file
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/webapp/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Change ownership to appuser
RUN chown -R appuser:appuser /usr/local/tomcat

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]