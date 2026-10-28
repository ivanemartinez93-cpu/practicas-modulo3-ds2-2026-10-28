-- Caso 1. Atomicidad: venta y auditoría deben confirmarse juntas.
-- Antes del BEGIN: stock 20 y 10; auditoría vacía.
SELECT * FROM productos ORDER BY id;
SELECT * FROM ventas_log ORDER BY id;
BEGIN TRANSACTION;
UPDATE productos SET stock = stock - 3 WHERE id = 1;
INSERT INTO ventas_log (id,producto_id,unidades,descripcion)
 VALUES (1,1,3,'Venta confirmada');
COMMIT;
-- Después del COMMIT: stock 17 y 10; una fila de auditoría.
-- La durabilidad se comprueba además cerrando y reabriendo la base desde Python.
SELECT * FROM productos ORDER BY id;
SELECT * FROM ventas_log ORDER BY id;
