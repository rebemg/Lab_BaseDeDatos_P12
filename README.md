# Práctica 12
Rebeca Moreno González

## Objetivo
Estudiar cómo funcionan las transacciones, la gestión de la concurrencia y asegurar que varias operaciones se ejecuten de forma atómica y consistente en presencia de múltiples usuarios.

## Decisiones

En esta práctica utilicé PostgreSQL para trabajar con transacciones, concurrencia y niveles de aislamiento. Para realizar las pruebas utilicé las tablas cliente, pedido e inventario que habían sido creadas en actividades anteriores dentro de la base de datos empresa.
Primero agregué una columna saldo a la tabla cliente para poder simular operaciones financieras y observar con mayor facilidad los efectos de las transacciones. Después realicé pruebas utilizando los comandos BEGIN, COMMIT, ROLLBACK y SAVEPOINT con el objetivo de comprobar cómo PostgreSQL gestiona los cambios realizados dentro de una transacción.
Posteriormente abrí dos sesiones simultáneas para simular operaciones concurrentes sobre los mismos registros. Esto me permitió observar el comportamiento de los bloqueos aplicados por PostgreSQL cuando dos transacciones intentan modificar la misma fila al mismo tiempo.
Además, investigué los fenómenos de concurrencia Dirty Read, Non-Repeatable Read y Phantom Read para comprender los problemas que pueden presentarse cuando varios usuarios acceden a los mismos datos. Finalmente analicé cómo los niveles de aislamiento READ COMMITTED, REPEATABLE READ y SERIALIZABLE ayudan a evitar inconsistencias en la información.

## Pruebas realizadas
**Para la actividad:**
- Verifiqué que las tablas cliente, pedido e inventario estuvieran disponibles en la base de datos.
- Agregué la columna saldo a la tabla cliente para realizar simulaciones de pagos y descuentos.
- Ejecuté transacciones utilizando BEGIN y COMMIT.
- Probé la reversión completa de cambios mediante ROLLBACK.
- Utilicé SAVEPOINT para revertir parcialmente una transacción.
- Inserté nuevos registros en la tabla pedido dentro de transacciones controladas.
- Actualicé saldos de clientes mediante operaciones transaccionales.
- Modifiqué registros de inventario para simular movimientos de stock.
- Abrí dos sesiones simultáneas para realizar operaciones concurrentes sobre el mismo registro.
- Observé los bloqueos generados cuando dos transacciones intentaban actualizar la misma fila.
- Verifiqué el funcionamiento de READ COMMITTED mediante consultas realizadas antes y después de un COMMIT.
- Probé el comportamiento de REPEATABLE READ para mantener una vista consistente de los datos durante una transacción.

**Para el reto:**

Investigué los fenómenos de concurrencia Dirty Read, Non-Repeatable Read y Phantom Read. Analicé la forma en que cada uno puede afectar la consistencia de la información cuando múltiples transacciones trabajan simultáneamente sobre la misma base de datos.
También revisé cómo PostgreSQL utiliza el mecanismo MVCC (Multi-Version Concurrency Control) para manejar el acceso concurrente a los datos. Gracias a este mecanismo, PostgreSQL evita las lecturas sucias y proporciona diferentes niveles de aislamiento para controlar el acceso a la información según las necesidades de cada aplicación.
Las pruebas permitieron observar que PostgreSQL protege automáticamente los registros mediante bloqueos cuando varias transacciones intentan modificarlos al mismo tiempo, garantizando así la integridad de los datos.

## Errores

Durante las pruebas de concurrencia encontré el mensaje "no hay transacción en curso" al ejecutar un COMMIT. Inicialmente pensé que existía un problema con la transacción, pero después comprobé que la operación ya había sido finalizada previamente, por lo que PostgreSQL simplemente indicaba que no existía una transacción activa para confirmar.

## Conclusión

Con esta práctica aprendí a utilizar transacciones para controlar operaciones que involucran varios cambios dentro de la base de datos. También comprendí la importancia de los comandos COMMIT, ROLLBACK y SAVEPOINT para garantizar que las operaciones se ejecuten de forma segura y consistente.
Las pruebas de concurrencia me permitieron observar cómo PostgreSQL administra el acceso simultáneo a los datos mediante bloqueos y mecanismos de aislamiento. Además, pude identificar los fenómenos Dirty Read, Non-Repeatable Read y Phantom Read, así como los niveles de aislamiento que ayudan a prevenirlos.
