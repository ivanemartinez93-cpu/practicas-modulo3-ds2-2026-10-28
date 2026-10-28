-- Entorno controlado para ACID: almacenes 1 y 2 del mismo producto.
CREATE TABLE productos (
 id INTEGER PRIMARY KEY, nombre TEXT NOT NULL, stock INTEGER NOT NULL CHECK(stock>=0)
);
CREATE TABLE ventas_log (
 id INTEGER PRIMARY KEY, producto_id INTEGER NOT NULL,
 unidades INTEGER NOT NULL, descripcion TEXT NOT NULL,
 FOREIGN KEY(producto_id) REFERENCES productos(id) DEFERRABLE INITIALLY DEFERRED
);
INSERT INTO productos (id,nombre,stock) VALUES
 (1,'Sensor - almacen A',20),(2,'Sensor - almacen B',10);
