"""Ejecuta DML y TCL y verifica resultados en bases SQLite aisladas."""
import argparse
from pathlib import Path
import sqlite3

ROOT = Path(__file__).resolve().parent


def ejecutar_sql(conn, nombre, espera_error=False):
    """Ejecuta sentencia por sentencia sin el COMMIT implícito de executescript."""
    print('\nARCHIVO:', nombre)
    pendiente = ''
    errores = 0
    for linea in (ROOT / nombre).read_text(encoding='utf-8').splitlines():
        if linea.lstrip().startswith('--'):
            continue
        pendiente += linea + '\n'
        if not sqlite3.complete_statement(pendiente):
            continue
        sentencia = pendiente.strip()
        pendiente = ''
        try:
            cursor = conn.execute(sentencia)
            if cursor.description:
                print(sentencia, '=>', cursor.fetchall())
        except sqlite3.IntegrityError as exc:
            if not espera_error or 'NOT NULL constraint failed: productos.stock' not in str(exc):
                if conn.in_transaction:
                    conn.rollback()
                raise
            errores += 1
            print('Error lógico esperado:', exc)
            # Continuamos hasta el ROLLBACK explícito del archivo SQL.
    assert errores == (1 if espera_error else 0), 'Número inesperado de errores'
    assert not conn.in_transaction, 'Transacción sin cerrar'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output-dir', default='resultados_nuevos')
    args = parser.parse_args()
    destino = Path(args.output_dir)
    destino.mkdir(parents=True, exist_ok=False)  # Preserva ejecuciones anteriores.
    with sqlite3.connect(destino / 'practica_dml.db', isolation_level=None) as conn:
        ejecutar_sql(conn, '01_dml.sql')
        assert conn.execute('SELECT ventas_totales FROM vendedores WHERE id=2').fetchone() == (10300.0,)
        assert conn.execute("SELECT id FROM vendedores WHERE zona='Internacional' ORDER BY id").fetchall() == [(2,),(3,),(5,)]
        assert conn.execute('SELECT zona FROM vendedores WHERE id=7').fetchone() == ('Norte',)
        assert conn.execute('SELECT COUNT(*) FROM vendedores WHERE id=99').fetchone() == (0,)
        assert conn.execute('SELECT COUNT(*) FROM vendedores').fetchone() == (7,)
    ruta_tcl = destino / 'practica_tcl.db'
    conn = sqlite3.connect(ruta_tcl, isolation_level=None)
    try:
        # FK diferida: el borrado puede observarse dentro de la transacción,
        # pero no podría confirmarse dejando una auditoría huérfana.
        conn.execute('PRAGMA foreign_keys = ON')
        ejecutar_sql(conn, '02_tcl_preparacion.sql')
        ejecutar_sql(conn, '03_tcl_commit.sql')
    finally:
        conn.close()
    conn = sqlite3.connect(ruta_tcl, isolation_level=None)
    try:
        conn.execute('PRAGMA foreign_keys = ON')
        esperado = [(1,'Sensor - almacen A',17),(2,'Sensor - almacen B',10)]
        assert conn.execute('SELECT * FROM productos ORDER BY id').fetchall() == esperado
        assert conn.execute('SELECT COUNT(*) FROM ventas_log').fetchone() == (1,)
        print('Durabilidad verificada tras cerrar y reabrir la base.')
        ejecutar_sql(conn, '04_tcl_rollback.sql')
        assert conn.execute('SELECT * FROM productos ORDER BY id').fetchall() == esperado
        ejecutar_sql(conn, '05_tcl_atomicidad.sql', espera_error=True)
        assert conn.execute('SELECT * FROM productos ORDER BY id').fetchall() == esperado
    finally:
        if conn.in_transaction:
            conn.rollback()
        conn.close()
    print('\nVERIFICACION COMPLETA: DML y los tres casos TCL correctos.')


if __name__ == '__main__':
    main()
