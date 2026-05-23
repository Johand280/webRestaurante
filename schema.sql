-- ==========================================
-- SCRIPT DE INICIALIZACIÓN DE LA BASE DE DATOS
-- Sistema de Gestión de Restaurante
-- ==========================================

CREATE DATABASE IF NOT EXISTS restaurante_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restaurante_db;

-- 1. TABLA DE ROLES
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- 2. TABLA DE USUARIOS
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password CHAR(64) NOT NULL, -- SHA-256 produce 64 caracteres hexadecimales
    telefono VARCHAR(20),
    rol_id INT NOT NULL,
    activo TINYINT(1) DEFAULT 1,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. TABLA DE CATEGORÍAS
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

-- 4. TABLA DE PRODUCTOS
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    precio_anterior DECIMAL(10, 2) DEFAULT NULL,
    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 5,
    categoria_id INT NOT NULL,
    imagen_url VARCHAR(500),
    disponible TINYINT(1) DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. TABLA DE PEDIDOS
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'PENDIENTE', -- PENDIENTE, EN_PROCESO, ENTREGADO, CANCELADO
    total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    observaciones TEXT,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES usuarios(id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. TABLA DE DETALLE DE PEDIDOS
CREATE TABLE IF NOT EXISTS detalle_pedidos (
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (pedido_id, producto_id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. TABLA DE HISTORIAL DE PRECIOS
CREATE TABLE IF NOT EXISTS historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    precio_anterior DECIMAL(10, 2) NOT NULL,
    precio_nuevo DECIMAL(10, 2) NOT NULL,
    usuario_id INT NOT NULL,
    motivo VARCHAR(255),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON UPDATE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- PRECARGA DE DATOS INICIALES (SEMILLAS)
-- ==========================================

-- Insertar roles estándar
INSERT INTO roles (id, nombre, descripcion) VALUES
(1, 'Administrador', 'Control total del sistema, inventario, reportes y gestión de usuarios'),
(2, 'Trabajador', 'Gestión operativa: actualización de stocks de cocina y despacho de comandas'),
(3, 'Cliente', 'Acceso al catálogo digital para realizar pedidos y revisar el historial personal')
ON DUPLICATE KEY UPDATE nombre=nombre;

-- Insertar usuarios de prueba (Contraseñas encriptadas con SHA-256 a través de la función SHA2)
-- Contraseñas:
-- - admin@restaurante.com   -> admin123
-- - worker@restaurante.com  -> worker123
-- - client@restaurante.com  -> client123
INSERT INTO usuarios (nombre, apellido, email, password, telefono, rol_id, activo) VALUES
('Carlos', 'Administrador', 'admin@restaurante.com', SHA2('admin123', 256), '3001234567', 1, 1),
('Ana', 'Trabajadora', 'worker@restaurante.com', SHA2('worker123', 256), '3007654321', 2, 1),
('Juan', 'Cliente', 'client@restaurante.com', SHA2('client123', 256), '3009998888', 3, 1)
ON DUPLICATE KEY UPDATE email=email;

-- Insertar algunas categorías de prueba
INSERT INTO categorias (id, nombre, descripcion, activo) VALUES
(1, 'Platos Fuertes', 'Cortes de carne, pastas y especialidades culinarias', 1),
(2, 'Bebidas', 'Jugos naturales, gaseosas y bebidas calientes', 1),
(3, 'Entradas', 'Aperitivos para abrir el apetito antes del plato fuerte', 1),
(4, 'Postres', 'Dulces y repostería artesanal para finalizar la experiencia', 1)
ON DUPLICATE KEY UPDATE nombre=nombre;

-- Insertar productos de prueba
INSERT INTO productos (nombre, descripcion, precio, stock, stock_minimo, categoria_id, imagen_url, disponible) VALUES
('Hamburguesa Premium', 'Carne angus de 150g, queso cheddar fundido, tocineta crujiente, lechuga y tomate en pan brioche.', 12.50, 20, 5, 1, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=400&q=80', 1),
('Pizza Napolitana', 'Masa artesanal delgada, salsa de tomate de la casa, queso mozzarella fresco, albahaca y aceite de oliva.', 10.90, 15, 3, 1, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=400&q=80', 1),
('Limonada Imperial', 'Limonada frapeada endulzada con un toque sutil de yerbabuena fresca.', 3.00, 50, 10, 2, 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=400&q=80', 1),
('Bastones de Mozzarella', '6 dedos de queso mozzarella apanados y crujientes, acompañados de salsa marinara.', 5.50, 30, 8, 3, 'https://images.unsplash.com/photo-1531749668029-2db88e4b76ce?auto=format&fit=crop&w=400&q=80', 1),
('Brownie con Helado', 'Brownie de chocolate caliente con nueces, acompañado de una bola de helado de vainilla.', 4.50, 12, 4, 4, 'https://images.unsplash.com/photo-1564355808539-22fda35bed7e?auto=format&fit=crop&w=400&q=80', 1)
ON DUPLICATE KEY UPDATE nombre=nombre;
