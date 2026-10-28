-- Práctica DML: base practica_dml.db. Datos ficticios de vendedores.
CREATE TABLE vendedores (
 id INTEGER PRIMARY KEY, nombre TEXT NOT NULL,
 ventas_totales REAL NOT NULL CHECK(ventas_totales >= 0),
 zona TEXT NOT NULL, fecha_ingreso TEXT NOT NULL
);
INSERT INTO vendedores (id,nombre,ventas_totales,zona,fecha_ingreso) VALUES
 (1,'Ana',9000,'Norte','2026-01-10'),
 (2,'Bruno',9800,'Sur','2026-02-05'),
 (3,'Carla',12000,'Norte','2026-03-01');
-- SELECT: identificar vendedores y ventas de la zona Norte.
SELECT nombre, ventas_totales FROM vendedores WHERE zona = 'Norte' ORDER BY id;
-- INSERT: incorporar dos vendedores con todos los campos.
INSERT INTO vendedores (id,nombre,ventas_totales,zona,fecha_ingreso)
 VALUES (4,'Diego',4000,'Este','2026-04-02');
INSERT INTO vendedores (id,nombre,ventas_totales,zona,fecha_ingreso)
 VALUES (5,'Elena',11000,'Oeste','2026-04-03');
-- INSERT masivo opcional: tres registros en una sentencia, incluido el de prueba.
INSERT INTO vendedores (id,nombre,ventas_totales,zona,fecha_ingreso) VALUES
 (6,'Fabian',2000,'Sur','2026-05-01'),
 (7,'Gabriela',10000,'Norte','2026-05-02'),
 (99,'Prueba',0,'Prueba','2026-05-03');
-- Verificar la fila antes de actualizar; la nueva venta es de 500 unidades.
SELECT id, ventas_totales FROM vendedores WHERE id = 2;
UPDATE vendedores SET ventas_totales = ventas_totales + 500 WHERE id = 2;
SELECT id, ventas_totales FROM vendedores WHERE id = 2;
-- Reto: cambiar solo quienes superan 10000, sin incluir el límite exacto.
UPDATE vendedores SET zona = 'Internacional' WHERE ventas_totales > 10000;
SELECT id, nombre, ventas_totales, zona FROM vendedores ORDER BY id;
-- DELETE selectivo: retirar exclusivamente el registro de prueba.
SELECT * FROM vendedores WHERE id = 99;
DELETE FROM vendedores WHERE id = 99;
-- Resultado esperado: cero filas para el id 99, siete vendedores en total.
SELECT * FROM vendedores WHERE id = 99;
SELECT COUNT(*) AS vendedores_finales FROM vendedores;
