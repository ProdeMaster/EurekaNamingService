# Deudas Técnicas - EurekaNamingService

## Tabla de Estado Consolidado

| # | Deuda | Estado | Prioridad | Estimado | Bloqueador |
|---|-------|--------|-----------|----------|-----------|
| 1 | Tests (unitarios + integración) | ❌ | ALTA | 4-5h | No |
| 2 | Documentación de configuración | ⚠️ | MEDIA | 1-2h | No |

## Deuda #1: Tests Unitarios e Integración (70% cobertura mínima)

### Estado Actual
❌ **No implementado**: Sólo existe el test base generado `EurekaNamingServiceApplicationTests.java` sin validaciones significativas.

### Descripción
Se requiere agregar cobertura de tests minimalista para validar:
- Arranque correcto de la aplicación
- Health check del servidor
- Registro de servicios
- Descubrimiento de servicios
- Configuración de Eureka

### Tests Requeridos

#### 1. EurekaNamingServiceApplicationTests.java

**Ubicación**: src/test/java/com/ProdeMaster/EurekaNamingService/EurekaNamingServiceApplicationTests.java

**Propósito**: Validar que la aplicación arranca correctamente

**Código esperado**:
```java
@SpringBootTest
class EurekaNamingServiceApplicationTests {

  @Test
  void contextLoads() {
    // Valida que el contexto de Spring se carga correctamente
  }

  @SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
  @Test
  void eurekaServerIsRunning() {
    // Valida que el servidor Eureka está activo
  }
}
```

#### 2. EurekaServerHealthTests.java

**Ubicación**: src/test/java/com/ProdeMaster/EurekaNamingService/EurekaServerHealthTests.java

**Propósito**: Validar health check del servidor

**Caso de prueba**:
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class EurekaServerHealthTests {

  @Autowired
  private TestRestTemplate restTemplate;

  @Test
  void healthCheckEndpointReturns200() {
    // GET /health → Debe retornar 200 OK
    ResponseEntity<String> response = restTemplate.getForEntity(
      "/health", String.class
    );
    assertEquals(200, response.getStatusCodeValue());
  }

  @Test
  void healthCheckReturnsUpStatus() {
    // Valida que status es "UP"
    ResponseEntity<Map> response = restTemplate.getForEntity(
      "/health", Map.class
    );
    assertEquals("UP", response.getBody().get("status"));
  }
}
```

#### 3. EurekaEndpointTests.java

**Ubicación**: src/test/java/com/ProdeMaster/EurekaNamingService/EurekaEndpointTests.java

**Propósito**: Validar endpoints de Eureka

**Casos de prueba**:
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class EurekaEndpointTests {

  @Autowired
  private TestRestTemplate restTemplate;

  @Test
  void eurekaAppsEndpointIsAccessible() {
    // GET /eureka/apps → Retorna 200 OK
    ResponseEntity<String> response = restTemplate.getForEntity(
      "/eureka/apps", String.class
    );
    assertEquals(200, response.getStatusCodeValue());
  }

  @Test
  void eurekaAppsReturnsXmlContent() {
    // Valida que respuesta es XML
    ResponseEntity<String> response = restTemplate.getForEntity(
      "/eureka/apps", String.class
    );
    assertTrue(response.getBody().contains("applications"));
  }
}
```

#### 4. EurekaConfigurationTests.java

**Ubicación**: src/test/java/com/ProdeMaster/EurekaNamingService/EurekaConfigurationTests.java

**Propósito**: Validar configuración de Eureka

**Casos de prueba**:
```java
@SpringBootTest
class EurekaConfigurationTests {

  @Autowired
  private EurekaServerConfigBean serverConfig;

  @Test
  void eurekaServerIsProperlyConfigured() {
    // Valida que servidor está bien configurado
    assertNotNull(serverConfig);
  }

  @Test
  void selfPreservationConfiguration() {
    // Valida configuración de self-preservation
    boolean enableSelfPreservation = serverConfig.shouldEnableSelfPreservation();
    assertTrue(enableSelfPreservation);
  }
}
```

### Dependencias Requeridas

Verificar que pom.xml contiene:

```xml
<!-- Ya presente -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-test</artifactId>
  <scope>test</scope>
</dependency>

<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>

<!-- Opcional pero recomendada para mejor testing y health checks -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### Comandos de Ejecución

```bash
# Ejecutar todos los tests
mvn test

# Ejecutar test específico
mvn test -Dtest=EurekaNamingServiceApplicationTests

# Ejecutar con cobertura (si está configurado)
mvn test jacoco:report
```

### Criterios de Aceptación

- [ ] Se crean 4 clases de test
- [ ] Todos los tests pasan (mvn test)
- [ ] Cobertura alcanza 70%+
- [ ] Sin errores de compilación
- [ ] Sin warnings relacionados con tests

### Estimación

- Escribir tests: 2-3 horas
- Debugging/Fixes: 1-2 horas
- Validación de cobertura: 30-60 minutos
- **Total**: 4-5 horas

---

## Deuda #2: Documentación de Configuración

### Estado Actual
⚠️ **Parcialmente documentada**: `application.properties` existe pero falta documentación detallada de las propiedades por defecto utilizadas al omitir configuraciones adicionales y las ya provistas.

### Descripción
Documentar todas las propiedades de application.properties y su impacto.

### Propiedades a Documentar

Basándote en el archivo analizado, documenta:

```properties
# Identificación de la aplicación
spring.application.name=EurekaNamingService
# Descripción: Nombre único de la aplicación en el registry

# Configuración del servidor
server.port=8761
# Descripción: Puerto en el que corre el servidor Eureka

# Configuración de Cliente Eureka
eureka.client.register-with-eureka=false
# Descripción: ¿El servidor Eureka se registra a sí mismo?
# Valor: false (el servidor NO se registra)

eureka.client.fetch-registry=false
# Descripción: ¿Descargar registry de otros servidores?
# Valor: false (ya que este ES el servidor)

# Integración con Config Server (Spring Cloud Config)
spring.config.import=optional:configserver:
# Descripción: Permite importar propiedades desde un servidor de configuración si existe
```

### Casos de Uso por Configuración

**Desarrollo Local**:
Se recomienda agregar al entorno de desarrollo:
```properties
eureka.server.enable-self-preservation=false
eureka.server.eviction-interval-timer-in-ms=10000
```

**Producción**:
Mantener el comportamiento por defecto de Spring Cloud Eureka Server para alta disponibilidad, y configurar múltiples peers.
```properties
eureka.server.enable-self-preservation=true
```

### Criterios de Aceptación

- [ ] Todas las propiedades están documentadas
- [ ] Cada propiedad tiene descripción de impacto
- [ ] Hay ejemplos para desarrollo y producción
- [ ] Documento está en docs/02-DEUDA_TECNICA.md

### Estimación

- Recopilar propiedades: 30 minutos
- Documentar cada una: 30-60 minutos
- Revisar y validar: 30 minutos
- **Total**: 1-2 horas

---

## Cronograma de Implementación Recomendado

### Semana 1
- **Días 1-3**: Implementar 4 clases de test (Deuda #1)
- **Día 4**: Validar cobertura y debugging
- **Día 5**: Documentar configuración detallada (Deuda #2)

### Total Estimado
- **Deuda #1**: 4-5 horas
- **Deuda #2**: 1-2 horas
- **Total**: 5-7 horas de trabajo

---

## Impacto en Otros Servicios

Si no se implementan estos tests y documentación:
- ❌ Riesgo de regresiones no detectadas
- ❌ Dificultad en onboarding de nuevos desarrolladores
- ⚠️ Falta de guía de configuración para diferentes ambientes
