-- ============================================
-- Script de Configuración de Schemas y Extensiones
-- E-Commerce Microservices
-- PostgreSQL 17
-- ============================================

\echo '=========================================='
\echo 'Configurando extensiones y schemas...'
\echo '=========================================='

-- ============================================
-- EXTENSIONES COMUNES
-- ============================================

-- Habilitar UUID para IDs únicos
\c db_usuarios
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
\echo '✓ UUID habilitado en db_usuarios'

\c db_catalogo
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
\echo '✓ UUID habilitado en db_catalogo'

\c db_pedidos
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
\echo '✓ UUID habilitado en db_pedidos'

\c db_pagos
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
\echo '✓ UUID habilitado en db_pagos'

\c db_notificaciones
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
\echo '✓ UUID habilitado en db_notificaciones'

-- ============================================
-- CONFIGURACIÓN DE AUDITORÍA (OPCIONAL)
-- ============================================

-- Función genérica para timestamps automáticos
\c db_usuarios
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

\c db_catalogo
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

\c db_pedidos
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

\c db_pagos
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

\c postgres

\echo ''
\echo '=========================================='
\echo '✓ Configuración completada'
\echo '=========================================='