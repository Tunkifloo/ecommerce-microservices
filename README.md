# E-Commerce Microservices

Sistema de comercio electrónico basado en arquitectura de microservicios.

##  Arquitectura

- **Java 21** con Virtual Threads (Project Loom)
- **Spring Boot 3.5.6 + Spring Cloud
- **PostgreSQL** (Database per Service pattern)
- **Apache Kafka** (Event-Driven con patrón Saga)
- **Docker** + Docker Compose

## Microservicios

1. **config-server** (8888) - Configuración centralizada
2. **api-gateway** (8080) - Puerta de entrada única
3. **servicio-usuarios** (8081) - Gestión de usuarios y autenticación
4. **servicio-catalogo** (8082) - Productos e inventario
5. **servicio-pedidos** (8083) - Orquestación de pedidos
6. **servicio-pagos** (8084) - Procesamiento de pagos
7. **servicio-notificaciones** (8085) - Notificaciones por email

## Inicio Rápido

### Prerequisitos
- Java 21+
- Maven 3.9+
- Docker & Docker Compose

### Levantar Infraestructura
```bash
docker-compose up -d
```

### Compilar Proyecto
```bash
mvn clean install
```

### Ejecutar Config Server
```bash
cd config-server
mvn spring-boot:run
```

## Acceso a Servicios

- **API Gateway**: http://localhost:8080
- **Config Server**: http://localhost:8888
- **Kafka UI**: http://localhost:8090
- **PostgreSQL**: localhost:5432

## Credenciales (Desarrollo)

- **PostgreSQL**: admin / admin123
- **Kafka**: Sin autenticación (desarrollo)

## Documentación

Ver la carpeta `/docs` para diagramas de arquitectura y flujos.

## Testing
```bash
mvn test
```

## Licencia

MIT License