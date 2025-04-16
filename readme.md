# Eureka Service Name

Este proyecto implementa un **servicio de nombres** usando **Spring Cloud Eureka Server**, parte de un sistema de microservicios. Permite el descubrimiento dinámico de servicios registrados.

## 🛠️ Tecnologías

- Java 17
- Spring Boot 3.4.x
- Spring Cloud (Eureka Server)
- Docker & Docker Compose

## 🚀 ¿Qué hace este servicio?

Este servicio actúa como un **Eureka Server** central para que los microservicios puedan registrarse y descubrirse entre sí dinámicamente, eliminando la necesidad de configuración estática de direcciones IP o puertos.

## 📁 Estructura del proyecto
```plaintext
eureka-service/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/ProdeMaster/EurekaNamingService/
│   │   │       └── EurekaNamingServiceApplication.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/java/com/ProdeMaster/EurekaNamingService
│       └── EurekaNamingServiceApplicationTests.java
├── Dockerfile
├── pom.xml
└── readme.md
```

## ⚙️ Configuración

El archivo `application.properties` contiene la configuración del servidor Eureka:

### application.properties
```plaintext
spring.application.name=EurekaNamingService
server.port=8761

spring.config.import=optional:configserver:

eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
```

## 🧪 Cómo probarlo en local
### ✅ Requisitos
- JDK 17
- Maven
- Docker

#### Opción 1: sin Docker
```bash
mvn spring-boot:run
```

#### Opción 2: con Docker
```bash
mvn clean package
docker image build -t eureka-service .
docker run eureka-service
```

## 📦 Docker

### Dockerfile

El servicio cuenta con un Dockerfile optimizado para producción basado en una imagen Java 17.

#### Build manual de la imagen
```bash
mvn clean package
docker image build -t eureka-service .
docker build -t eurekaservice .
```
> Es necesario empaquetar la aplicación con `mvn clean package` antes de crear la imagen de docker 

## 🧩 Integración con otros servicios

Los demás microservicios deben tener una configuración como la siguiente en su **application.properties:**
`eureka.client.service-url.defaultZone=http://eureka-service:8761/eureka`
Y el nombre del host eureka-service debe coincidir con el nombre del contenedor en Docker Compose.

## 📚 Documentación adicional
* [Spring Boot](https://docs.spring.io/spring-boot/index.html)
* [Spring cloud](https://docs.spring.io/spring-cloud/docs/current/reference/html/)
* [Spring Cloud Eureka Docs](https://docs.spring.io/spring-cloud-netflix/docs/current/reference/html/)
* [Ciclo de vida de las aplicaciones con Maven](https://keepcoding.io/blog/que-es-maven-lifecycle-y-sus-fases/)
* [Docker Compose Docs](https://docs.docker.com/compose/)

## 🧑‍💻 Autor
> Nombre: Gastón Herrlein
>
> GitHub: @Gaston-Herrlein

## 📄 Licencia
Sin licencia