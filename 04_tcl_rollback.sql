-- Caso 2. Atomicidad: revertir un borrado accidental en este entorno de prueba.
-- Antes: dos productos, con stock 17 y 10.
SELECT * FROM productos ORDER BY id;
BEGIN TRANSACTION;
-- Borrado SIN WHERE intencional, solicitado para demostrar ROLLBACK.
-- No ejecutar sobre datos productivos. La auditoría se conserva separada.
DELETE FROM productos;
-- Durante la transacción: cero productos.
SELECT * FROM productos ORDER BY id;
ROLLBACK;
-- Después del ROLLBACK: se recuperan ambas filas con los valores anteriores.
SELECT * FROM productos ORDER BY id;
