# Use official Maven image with Eclipse Temurin JDK on Alpine
FROM maven:3.8.6-eclipse-temurin-17-alpine

# Set environment variables for Maven caching
ENV MAVEN_OPTS="-Dmaven.repo.local=/usr/share/maven/ref/repository -Dmaven.wagon.http.retryHandler.count=3"
ENV MAVEN_CACHE="/usr/share/maven/ref/repository"

# Set working directory
WORKDIR /app

# Copy pom.xml first to leverage Docker cache
COPY pom.xml .

# Download dependencies and plugins (this layer will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline --fail-never

# Copy source code
COPY src ./src

# Create non-root user and set permissions
RUN addgroup -S maven && adduser -S maven -G maven
RUN chown -R maven:maven /app
USER maven

# Default command (can be overridden in GitHub Actions)
ENTRYPOINT ["mvn"]