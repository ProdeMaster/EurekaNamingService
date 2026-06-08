# EurekaNamingService - Resumen Ejecutivo

## Descripción General
EurekaNamingService es el servidor Eureka de la arquitectura de microservicios de ProdeMaster.
Actúa como registry centralizado que permite el descubrimiento automático de servicios.

## Información Técnica
- **Versión Spring Boot**: 3.4.3
- **Versión Spring Cloud**: 2024.0.0
- **Puerto**: 8761
- **Hostname**: localhost (por defecto en despliegues locales)

## Responsabilidades Principales
1. **Registro de servicios**: Recibe y almacena registros de instancias de servicios
2. **Mantener registry actualizado**: Procesa heartbeats de servicios registrados
3. **Descubrimiento de servicios**: Proporciona lista de instancias disponibles
4. **Monitoreo de salud**: Rastrea health de instancias registradas
5. **Eliminación automática**: Remueve instancias no disponibles

## Arquitectura Minimalista
- Implementación mínima según recomendaciones Spring Boot
- Sin lógica de negocio adicional, incluye únicamente `@EnableEurekaServer`
- Configuración estándar de Eureka mediante `application.properties`
- Sin dependencias externas adicionales como base de datos o colas

## Servicios Registrados
Los siguientes servicios (si existen en la arquitectura general de ProdeMaster) se registrarán automáticamente en Eureka si lo configuran como su Discovery Server:

| Servicio | Propósito | Integración |
|----------|-----------|-------------|
| UserService | Gestión de usuarios y autenticación | API Gateway valida tokens |
| MatchService | Gestión de partidos/matches | Consumido por otros servicios |
| PredictionService | Gestión de predicciones | Descubierto por otros servicios |
| ApiGateway | Gateway de API | Descubre todos los servicios |

## Endpoints Principales
- **Dashboard**: http://[hostname]:8761/
- **API de apps**: http://[hostname]:8761/eureka/apps
- **Health check**: http://[hostname]:8761/health (requiere agregar Actuator)

## Características Clave
- **Self-preservation**: Habilitado por defecto en Eureka (no sobreescrito en properties)
- **Registro propio**: Deshabilitado (`eureka.client.register-with-eureka=false`)
- **Descarga de registry**: Deshabilitada (`eureka.client.fetch-registry=false`)
- **Importación de config**: `optional:configserver:` (Integración con Spring Cloud Config Server si estuviese presente)

## Deudas Técnicas
1. **Tests**: ❌ No hay cobertura de tests útil. Sólo existe un test base que carga el contexto de Spring (Necesario: 70% mínimo de cobertura)
2. **Documentación**: ⚠️ Documentación de integración pendiente

## Próximos Pasos
1. Agregar tests unitarios e integración (Estimado: 4-5 horas)
2. Documentar configuración detallada de application.properties
3. Crear guía de troubleshooting
4. Implementar métricas y monitoreo avanzado mediante Spring Boot Actuator

## Contacto
Equipo responsable de infraestructura de ProdeMaster

---

**Generado**: 2026-05-26 - Gemini 3.1 Pro High (Antigravity)
**Última actualización**: 2026-05-26
