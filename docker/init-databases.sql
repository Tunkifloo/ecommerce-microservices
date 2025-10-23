-- ============================================
-- Script de Inicialización de Bases de Datos
-- E-Commerce Microservices
-- PostgreSQL 17
-- ============================================

-- Conexión: postgres database como admin

\echo '=========================================='
\echo 'Iniciando creación de bases de datos...'
\echo '=========================================='

-- ============================================
-- 1. CREACIÓN DE BASES DE DATOS LÓGICAS
-- ============================================

-- Database per Service Pattern
-- Cada microservicio tiene su propia base de datos aislada

\echo 'Creando bases de datos...'

CREATE DATABASE db_usuarios
    WITH
    OWNER = admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    TEMPLATE template0;

CREATE DATABASE db_catalogo
    WITH
    OWNER = admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    TEMPLATE template0;

CREATE DATABASE db_pedidos
    WITH
    OWNER = admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    TEMPLATE template0;

CREATE DATABASE db_pagos
    WITH
    OWNER = admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    TEMPLATE template0;

CREATE DATABASE db_notificaciones
    WITH
    OWNER = admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    TEMPLATE template0;

\echo '✓ Bases de datos creadas correctamente'

-- ============================================
-- 2. CREACIÓN DE USUARIOS POR SERVICIO
-- ============================================

\echo ''
\echo 'Creando usuarios específicos por servicio...'

-- Principio de Least Privilege: Cada servicio solo accede a su BD

CREATE USER user_usuarios WITH
    PASSWORD 'pass_usuarios'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOINHERIT
    LOGIN
    CONNECTION LIMIT 20;

CREATE USER user_catalogo WITH
    PASSWORD 'pass_catalogo'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOINHERIT
    LOGIN
    CONNECTION LIMIT 20;

CREATE USER user_pedidos WITH
    PASSWORD 'pass_pedidos'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOINHERIT
    LOGIN
    CONNECTION LIMIT 20;

CREATE USER user_pagos WITH
    PASSWORD 'pass_pagos'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOINHERIT
    LOGIN
    CONNECTION LIMIT 20;

CREATE USER user_notificaciones WITH
    PASSWORD 'pass_notif'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOINHERIT
    LOGIN
    CONNECTION LIMIT 10;

\echo '✓ Usuarios creados correctamente'

-- ============================================
-- 3. ASIGNACIÓN DE PERMISOS EXCLUSIVOS
-- ============================================

\echo ''
\echo 'Asignando permisos exclusivos...'

-- Cada usuario SOLO puede acceder a su base de datos

GRANT ALL PRIVILEGES ON DATABASE db_usuarios TO user_usuarios;
GRANT ALL PRIVILEGES ON DATABASE db_catalogo TO user_catalogo;
GRANT ALL PRIVILEGES ON DATABASE db_pedidos TO user_pedidos;
GRANT ALL PRIVILEGES ON DATABASE db_pagos TO user_pagos;
GRANT ALL PRIVILEGES ON DATABASE db_notificaciones TO user_notificaciones;

\echo '✓ Permisos asignados correctamente'

-- ============================================
-- 4. CONFIGURACIÓN DE SCHEMAS POR DEFECTO
-- ============================================

-- Conectar a cada base de datos y configurar el schema public

\c db_usuarios
GRANT ALL ON SCHEMA public TO user_usuarios;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO user_usuarios;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO user_usuarios;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO user_usuarios;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO user_usuarios;

\c db_catalogo
GRANT ALL ON SCHEMA public TO user_catalogo;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO user_catalogo;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO user_catalogo;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO user_catalogo;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO user_catalogo;

\c db_pedidos
GRANT ALL ON SCHEMA public TO user_pedidos;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO user_pedidos;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO user_pedidos;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO user_pedidos;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO user_pedidos;

\c db_pagos
GRANT ALL ON SCHEMA public TO user_pagos;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO user_pagos;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO user_pagos;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO user_pagos;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO user_pagos;

\c db_notificaciones
GRANT ALL ON SCHEMA public TO user_notificaciones;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO user_notificaciones;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO user_notificaciones;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO user_notificaciones;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO user_notificaciones;

-- Volver a la base de datos postgres
\c postgres

\echo ''
\echo '=========================================='
\echo '✓ Inicialización completada exitosamente'
\echo '=========================================='
\echo ''
\echo 'Bases de datos creadas:'
\echo '  - db_usuarios (user_usuarios)'
\echo '  - db_catalogo (user_catalogo)'
\echo '  - db_pedidos (user_pedidos)'
\echo '  - db_pagos (user_pagos)'
\echo '  - db_notificaciones (user_notificaciones)'
\echo ''
\echo 'Conexión de ejemplo:'
\echo '  psql -h localhost -p 5432 -U user_usuarios -d db_usuarios'
\echo '=========================================='