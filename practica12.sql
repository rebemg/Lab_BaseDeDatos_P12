DROP TABLE IF EXISTS empleado CASCADE;
DROP TABLE IF EXISTS departamento CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS producto CASCADE;
DROP TABLE IF EXISTS detalle_pedido CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS inventario CASCADE;

CREATE TABLE IF NOT EXISTS empleado (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    puesto VARCHAR(50),
    salario NUMERIC(10,2),
    fecha_contratacion DATE
);


CREATE TABLE IF NOT EXISTS departamento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS cliente (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS producto (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10,2)
);


CREATE TABLE IF NOT EXISTS pedido (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES cliente(id),
    fecha DATE NOT NULL
);


CREATE TABLE IF NOT EXISTS detalle_pedido (
    pedido_id INT NOT NULL REFERENCES pedido(id),
    producto_id INT NOT NULL REFERENCES producto(id),
    cantidad INT NOT NULL,
    PRIMARY KEY(pedido_id, producto_id)
);

CREATE TABLE inventario (
    producto_id INT PRIMARY KEY REFERENCES producto(id),
    stock INT NOT NULL
);

INSERT INTO empleado (nombre, puesto, salario, fecha_contratacion)
VALUES 
('Ana Torres', 'Analista', 15000, '2026-10-02'),
('Luis Gómez', 'Gerente', 30000, '2026-09-15'),
('Marta Ruiz', 'Desarrolladora', 22000, '2026-08-10'),
('Carlos Pérez', 'Soporte', 14000, '2026-07-01'),
('Diana López', 'Analista', 16000, '2026-10-01');

INSERT INTO departamento (nombre)
VALUES 
('Recursos Humanos'),
('Finanzas'),
('Tecnología'),
('Ventas');

INSERT INTO cliente (nombre, direccion) VALUES
('Luis Gómez', 'Av. Universidad 123'),
('Marta Ruiz', 'Calle Reforma 456'),
('Carlos Pérez', 'Av. Central 789'),
('Diana López', 'Calle Norte 22'),
('Ana Torres', 'Av. Sur 77');

INSERT INTO producto (nombre, precio) VALUES
('Libro A', 250.00),
('Libro B', 300.00),
('Libro C', 150.00),
('Laptop', 25000.00),
('Mouse', 500.00);

INSERT INTO pedido (cliente_id, fecha) VALUES
(1, '2026-10-05'),
(2, '2026-10-06'),
(3, '2026-10-07'),
(4, '2026-10-08'),
(5, '2026-10-09');

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad)
VALUES 
(1, 1, 2),
(1, 2, 1),
(2, 3, 3),
(3, 4, 1),
(4, 5, 2),
(5, 2, 1)
ON CONFLICT (pedido_id, producto_id)
DO UPDATE SET cantidad = detalle_pedido.cantidad + EXCLUDED.cantidad;

INSERT INTO inventario (producto_id, stock)
VALUES
(1, 100),
(2, 50),
(3, 80),
(4, 30),
(5, 20);

ALTER TABLE cliente
ADD COLUMN saldo NUMERIC(10,2) DEFAULT 0;

UPDATE cliente SET saldo = 5000 WHERE id = 1;
UPDATE cliente SET saldo = 3500 WHERE id = 2;
UPDATE cliente SET saldo = 4200 WHERE id = 3;
UPDATE cliente SET saldo = 2800 WHERE id = 4;
UPDATE cliente SET saldo = 6000 WHERE id = 5;

-- Transacción
BEGIN;

INSERT INTO pedido(cliente_id, fecha)
VALUES (1, CURRENT_DATE);

UPDATE cliente
SET saldo = saldo - 100
WHERE id = 1;

COMMIT;

--Rollback
BEGIN;

UPDATE cliente
SET saldo = saldo - 500
WHERE id = 1;

ROLLBACK;

--Savepoint
BEGIN;

UPDATE cliente
SET saldo = saldo - 100
WHERE id = 1;

SAVEPOINT punto1;

UPDATE cliente
SET saldo = saldo - 200
WHERE id = 1;

ROLLBACK TO SAVEPOINT punto1;

COMMIT;

-- Concurrencia
BEGIN;

UPDATE cliente
SET saldo = saldo - 300
WHERE id = 1;

BEGIN;

UPDATE cliente
SET saldo = saldo - 200
WHERE id = 1;

COMMIT;

COMMIT;

SELECT * FROM cliente
WHERE id = 1;