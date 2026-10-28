# Prácticas opcionales del módulo 3 · Data Science II

Iván Martínez · Versión 1 · 28/10/2026.

Este repositorio contiene cuatro actividades independientes del módulo Data Acquisition de Datos. La pre-entrega final de Pandas no forma parte de estas prácticas.

## Reproducir DML y TCL

Requiere Python 3.10 o posterior. Solo usa la biblioteca estándar (`sqlite3`, `pathlib`, `argparse`); no se necesitan paquetes ni credenciales. Descargar el repositorio como ZIP, extraerlo y abrir una terminal en la raíz. Ejecutar:

```text
python ejecutar_practicas.py --output-dir mi_ejecucion
```

En Windows puede usarse `py`; en otros sistemas, `python3`. La carpeta de salida debe ser nueva: el programa rechaza una existente para conservar ejecuciones previas. Dentro crea `practica_dml.db` y `practica_tcl.db`. La salida real verificada con Python 3.12.14 está en `evidencia_ejecucion.txt`; también se incluyen copias de las dos bases resultantes en la raíz del repositorio.

### Actividad DML · Unidad 7

`01_dml.sql` crea la tabla vendedores con los cinco campos solicitados y datos ficticios. Consulta nombre y ventas de Norte, inserta dos vendedores y tres registros adicionales en una sentencia, suma 500 a las ventas del id 2, cambia a Internacional quienes superan 10000 y elimina el registro de prueba id 99. Todos los UPDATE y DELETE de esta práctica incluyen WHERE.

Verificación automática: id 2 termina con 10300; ids 2, 3 y 5 quedan en Internacional; id 7, con exactamente 10000, conserva Norte; id 99 desaparece; quedan siete vendedores. Los SELECT antes y después se imprimen en la evidencia.

### Actividad TCL · Unidad 8

| Archivo | Problema y principio ACID | Evidencia esperada |
| --- | --- | --- |
| `02_tcl_preparacion.sql` | Crea productos y ventas_log; dos filas representan existencias del mismo producto en almacenes A y B | Stock inicial 20 y 10 |
| `03_tcl_commit.sql` | Venta con auditoría como unidad atómica; COMMIT y durabilidad | Stock 17 y 10 y una fila de log, incluso al cerrar y reabrir la base |
| `04_tcl_rollback.sql` | Deshacer un DELETE sin WHERE accidental dentro de una transacción de prueba | Cero filas dentro de la transacción; vuelven ambas tras ROLLBACK |
| `05_tcl_atomicidad.sql` | Revertir dos pasos cuando el segundo viola NOT NULL | Primer UPDATE reduce A a 12; falla el segundo; ROLLBACK devuelve A=17 y B=10 |

El fallo lógico del caso 3 es intencional y se captura como `sqlite3.IntegrityError`; el SQL no tiene un error de sintaxis. El ejecutor continúa con el ROLLBACK explícito y verifica que ninguna transacción quede abierta. Se ejecuta sentencia por sentencia para evitar el COMMIT implícito de `executescript`. La FK de auditoría es diferida: permite observar el borrado temporal del caso 2, pero impediría confirmar una referencia huérfana. Las claves foráneas están activadas.

## Actividades visuales

### DAQ · Unidad 3

`DAQ_Aerogenerador_v1_2026-10-28.png` muestra fenómeno físico → acelerómetro/transductor → acondicionamiento y filtro antialias → ADC → software y CSV/base. Identifica al ADC como punto de digitalización. Para una banda útil que llega a 200 Hz, propone 2000 muestras/s y un ADC de 24 bits nominales, con justificación, supuestos y validación de resolución efectiva. Explica dos riesgos (sensor/cableado y filtro/ADC), sus efectos sobre ML y mitigaciones. Es un diseño teórico, no una validación de hardware instalado.

### Ecosistema Big Data · Unidad 9

`Ecosistema_BigData_v1_2026-10-28.png` contiene las cinco V, tres fuentes diferenciadas por estructura y cuatro etapas con flechas de izquierda a derecha: ingesta batch/streaming, almacenamiento Data Lake/Cloud Storage, procesamiento distribuido con feature engineering, análisis/ML y valor de negocio. Detalla dos límites locales: recursos de una máquina y contención de escritura en SQLite.

Ambas imágenes fueron abiertas y verificadas como PNG y pesan menos de 10 MB.

## Referencias técnicas

- [National Instruments: ancho de banda, Nyquist y aliasing](https://www.ni.com/en/shop/data-acquisition/measurement-fundamentals/analog-fundamentals/acquiring-an-analog-signal--bandwidth--nyquist-sampling-theorem-.html)
- [National Instruments: selección de hardware DAQ](https://www.ni.com/en/shop/data-acquisition/how-to-choose-the-right-daq-hardware-for-your-measurement-system.html)
- [SQLite: transacciones y concurrencia](https://www.sqlite.org/lang_transaction.html)
- [SQLite: resolución de conflictos](https://www.sqlite.org/conflict.html)

Los archivos TXT correspondientes son copias idénticas y completas de cada script. Las bases contienen exclusivamente registros ficticios de práctica.
