FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/EurekaNamingService-0.0.1-SNAPSHOT.jar EurekaNamingService-0.0.1-SNAPSHOT.jar

EXPOSE 8761

LABEL version="0.1"
LABEL description="Application corresponding to the naming service used in the ProdeMaster project"

LABEL org.opencontainer.java.version="17"
LABEL org.opencontainer.Spring.version="3.4.*"
LABEL org.opencontainer.mvn.version="3.9.9"


ENTRYPOINT ["java", "-jar", "EurekaNamingService-0.0.1-SNAPSHOT.jar"]
