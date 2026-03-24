FROM maven:3.9.6-eclipse-temurin-11

WORKDIR /app

COPY pom.xml .

COPY src ./src

RUN mvn clean package -DskipTests

EXPOSE 8080

CMD ["java", "-jar", "target/todo-1.0.0.jar"]