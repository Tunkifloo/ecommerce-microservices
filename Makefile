.PHONY: help infra-up infra-down infra-logs infra-clean db-connect kafka-ui clean build test

# Colores para output
CYAN := \033[0;36m
GREEN := \033[0;32m
RED := \033[0;31m
RESET := \033[0m

help: ## Mostrar este mensaje de ayuda
	@echo "$(CYAN)E-Commerce Microservices - Comandos Disponibles$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}'

# ============================================
# INFRAESTRUCTURA
# ============================================

infra-up: ## Levantar toda la infraestructura (PostgreSQL + Kafka)
	@echo "$(CYAN)🚀 Levantando infraestructura...$(RESET)"
	docker-compose up -d
	@echo "$(GREEN)✓ Infraestructura levantada$(RESET)"
	@echo ""
	@echo "$(CYAN)Servicios disponibles:$(RESET)"
	@echo "  - PostgreSQL: localhost:5432"
	@echo "  - Kafka: localhost:9092"
	@echo "  - Kafka UI: http://localhost:8090"

infra-down: ## Detener la infraestructura
	@echo "$(CYAN)🛑 Deteniendo infraestructura...$(RESET)"
	docker-compose down
	@echo "$(GREEN)✓ Infraestructura detenida$(RESET)"

infra-restart: ## Reiniciar la infraestructura
	@echo "$(CYAN)🔄 Reiniciando infraestructura...$(RESET)"
	docker-compose restart
	@echo "$(GREEN)✓ Infraestructura reiniciada$(RESET)"

infra-logs: ## Ver logs de la infraestructura
	docker-compose logs -f

infra-clean: ## Limpiar contenedores y volúmenes
	@echo "$(RED)⚠️  Eliminando contenedores y volúmenes...$(RESET)"
	docker-compose down -v
	@echo "$(GREEN)✓ Limpieza completada$(RESET)"

infra-status: ## Ver estado de los contenedores
	@echo "$(CYAN)Estado de la infraestructura:$(RESET)"
	@docker-compose ps

# ============================================
# BASE DE DATOS
# ============================================

db-connect: ## Conectar a PostgreSQL (admin)
	@echo "$(CYAN)Conectando a PostgreSQL como admin...$(RESET)"
	@docker exec -it $${POSTGRES_CONTAINER_NAME:-ecommerce-postgres} psql -U $${POSTGRES_USER:-admin} -d $${POSTGRES_DB:-postgres}

db-connect-users: ## Conectar a db_usuarios
	docker exec -it ecommerce-postgres psql -U user_usuarios -d db_usuarios

db-connect-catalog: ## Conectar a db_catalogo
	docker exec -it ecommerce-postgres psql -U user_catalogo -d db_catalogo

db-connect-orders: ## Conectar a db_pedidos
	docker exec -it ecommerce-postgres psql -U user_pedidos -d db_pedidos

db-list: ## Listar todas las bases de datos
	docker exec -it ecommerce-postgres psql -U admin -d postgres -c '\l'

# ============================================
# KAFKA
# ============================================

kafka-ui: ## Abrir Kafka UI en el navegador
	@echo "$(CYAN)Abriendo Kafka UI...$(RESET)"
	@echo "$(GREEN)http://localhost:8090$(RESET)"

kafka-topics: ## Listar tópicos de Kafka
	docker exec -it ecommerce-kafka kafka-topics --bootstrap-server localhost:9092 --list

kafka-create-topics: ## Crear tópicos iniciales de la Saga
	@echo "$(CYAN)Creando tópicos de Kafka...$(RESET)"
	docker exec -it ecommerce-kafka kafka-topics --bootstrap-server localhost:9092 --create --topic topico-pedidos --partitions 3 --replication-factor 1 --if-not-exists
	docker exec -it ecommerce-kafka kafka-topics --bootstrap-server localhost:9092 --create --topic topico-inventario --partitions 3 --replication-factor 1 --if-not-exists
	docker exec -it ecommerce-kafka kafka-topics --bootstrap-server localhost:9092 --create --topic topico-pagos --partitions 3 --replication-factor 1 --if-not-exists
	@echo "$(GREEN)✓ Tópicos creados$(RESET)"

# ============================================
# PROYECTO
# ============================================

build: ## Compilar todos los microservicios
	@echo "$(CYAN)Compilando proyecto...$(RESET)"
	mvn clean install -DskipTests
	@echo "$(GREEN)✓ Compilación exitosa$(RESET)"

test: ## Ejecutar tests
	@echo "$(CYAN)Ejecutando tests...$(RESET)"
	mvn test

clean: ## Limpiar archivos de compilación
	@echo "$(CYAN)Limpiando proyecto...$(RESET)"
	mvn clean
	@echo "$(GREEN)✓ Limpieza completada$(RESET)"

run-config-server: ## Ejecutar Config Server
	@echo "$(CYAN)Iniciando Config Server...$(RESET)"
	cd config-server && mvn spring-boot:run

# ============================================
# UTILIDADES
# ============================================

check-ports: ## Verificar puertos en uso
	@echo "$(CYAN)Verificando puertos...$(RESET)"
	@echo "PostgreSQL (5432):"
	@lsof -i :5432 || echo "  Puerto disponible"
	@echo "Kafka (9092):"
	@lsof -i :9092 || echo "  Puerto disponible"
	@echo "Config Server (8888):"
	@lsof -i :8888 || echo "  Puerto disponible"

show-config: ## Mostrar configuración actual
	@echo "$(CYAN)Configuración de variables:$(RESET)"
	@cat .env.example 2>/dev/null || echo "No hay archivo .env"