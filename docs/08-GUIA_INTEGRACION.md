# Guía de Integración - EurekaNamingService

## Cómo Registrar un Servicio con Eureka

### Paso 1: Agregar Dependencia en pom.xml

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

### Paso 2: Configurar application.properties

```properties
spring.application.name=my-service

eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
eureka.instance.hostname=localhost
eureka.instance.prefer-ip-address=true
eureka.instance.lease-renewal-interval-in-seconds=10
eureka.instance.lease-expiration-duration-in-seconds=30
```

### Paso 3: Habilitar Eureka Client

En la clase principal de Spring Boot 3, la dependencia autoconfigura al cliente por defecto. Se puede añadir explícitamente `@EnableDiscoveryClient` si se desea documentar mejor.

```java
@SpringBootApplication
@EnableDiscoveryClient
public class MyServiceApplication {
  public static void main(String[] args) {
    SpringApplication.run(MyServiceApplication.class, args);
  }
}
```

---

## Servicios Registrados y Descubrimiento

### Servicios en la Arquitectura (Ejemplo)

| Servicio | Nombre Eureka | Puerto | Propósito |
|----------|---------------|--------|----------|
| UserService | user-service | 8081 | Autenticación y gestión de usuarios |
| MatchService | match-service | 8082 | Gestión de partidos |
| PredictionService | prediction-service | 8083 | Gestión de predicciones |
| ApiGateway | api-gateway | 8080 | Gateway de API |

### Cómo ApiGateway Descubre UserService

```
1. ApiGateway inicia
   └─ Se registra en Eureka: "api-gateway"
   
2. ApiGateway necesita validar un token
   └─ Consulta a Eureka: ¿Dónde está user-service?
   
3. Eureka responde con detalles de instancia:
   {
     "hostname": "192.168.1.100",
     "port": 8081,
     "status": "UP"
   }
   
4. ApiGateway llama a UserService:
   GET http://user-service/api/v1/auth/validate-token
   └─ Spring Cloud resuelve "user-service" a IP/puerto desde Eureka
   
5. UserService responde con resultado de validación
```

### Cómo Descubrir Servicios Programáticamente

#### Opción 1: RestTemplate con @LoadBalanced (Simple)

```java
@Configuration
public class RestClientConfig {
  
  @Bean
  @LoadBalanced
  public RestTemplate restTemplate() {
    return new RestTemplate();
  }
}
```

Uso en ApiGateway:

```java
@Autowired
private RestTemplate restTemplate;

public TokenValidationResponse validateToken(String token) {
  // Spring Cloud resuelve "user-service" automáticamente
  return restTemplate.getForObject(
    "http://user-service/api/v1/auth/validate-token?token={token}",
    TokenValidationResponse.class,
    token
  );
}
```

#### Opción 2: WebClient (Moderno, Reactivo)

```java
@Configuration
public class WebClientConfig {
  
  @Bean
  @LoadBalanced
  public WebClient.Builder webClientBuilder() {
    return WebClient.builder();
  }
}
```

Uso:

```java
@Autowired
private WebClient.Builder webClientBuilder;

public Mono<TokenValidationResponse> validateTokenAsync(String token) {
  return webClientBuilder.build()
    .get()
    .uri("http://user-service/api/v1/auth/validate-token?token={token}", token)
    .retrieve()
    .bodyToMono(TokenValidationResponse.class);
}
```

## Monitoreo de Servicios en Eureka

### Ver Dashboard de Eureka

```
http://localhost:8761
```

Muestra:
- Servicios registrados
- Instancias de cada servicio
- Status (UP/DOWN)
- Último heartbeat
- Metadata de la instancia

### Verificar Salud de una Instancia

```bash
curl http://localhost:8761/eureka/apps/user-service

# Respuesta XML/JSON con detalles de instancia
```

### Solucionar Problemas

**Servicio no aparece en Eureka**:
1. Verificar que EurekaNamingService está corriendo en el puerto 8761.
2. Verificar `eureka.client.service-url.defaultZone` en properties.
3. Ver logs del servicio cliente.

**Servicio aparece como DOWN**:
1. Verificar endpoint `/health` del cliente.
2. Verificar configuración de `lease-renewal-interval-in-seconds`.
3. Ver logs de health check.

**Tráfico no llega al servicio tras obtener instancia de Eureka**:
1. Verificar que hostname/IP es alcanzable en la red.
2. Verificar puerto está correcto.
3. Verificar firewall entre servicios.
4. Probar conectividad: `curl http://[hostname]:[puerto]/health`

---

## Mejores Prácticas

### En Desarrollo
- Self-preservation: DESHABILITADO (para remover servicios que cerramos manual y abruptamente)
- Tiempos de renovación: BAJOS (10-30 segundos)
- Eviction: RÁPIDA

### En Producción
- Self-preservation: HABILITADO
- Tiempos de renovación: ALTOS (30-60 segundos)
- Eviction: LENTA pero consistente

### Configuración Recomendada por Ambiente

**development/application-dev.properties**:
```properties
eureka.server.enable-self-preservation=false
eureka.server.eviction-interval-timer-in-ms=10000
eureka.instance.lease-renewal-interval-in-seconds=10
eureka.instance.lease-expiration-duration-in-seconds=30
```

**production/application-prod.properties**:
```properties
eureka.server.enable-self-preservation=true
eureka.server.eviction-interval-timer-in-ms=60000
eureka.instance.lease-renewal-interval-in-seconds=30
eureka.instance.lease-expiration-duration-in-seconds=90
```
