-- Caso 3. Atomicidad y consistencia: transferencia entre dos almacenes.
SELECT * FROM productos ORDER BY id;
BEGIN TRANSACTION;
UPDATE productos SET stock = stock - 5 WHERE id = 1;
-- El primer paso deja temporalmente stock A=12.
SELECT * FROM productos ORDER BY id;
-- Fallo lógico intencional: stock es NOT NULL. No es un error de sintaxis.
-- SQLite ABORT revierte esta sentencia, pero no el UPDATE previo.
UPDATE productos SET stock = NULL WHERE id = 2;
-- El ejecutor detecta la excepción y ejecuta ROLLBACK explícito.
-- Si se ejecuta en otra herramienta, continuar con ROLLBACK tras el error.
ROLLBACK;
-- Estado final esperado A=17, B=10: el primer UPDATE también se deshizo.
SELECT * FROM productos ORDER BY id;
