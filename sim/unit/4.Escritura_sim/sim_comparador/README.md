# Simulación unitaria: comparadores de manecillas

## Qué comprueba

Barre los 256 valores posibles del contador angular y compara cada uno con tres posiciones fijas: segundos en 128, minutos en 64 y horas en 21.

## Ejecutar

Desde esta carpeta: `make` ejecuta la prueba; `make wave` abre `sim_comparadores.vcd`; `make clean` limpia los resultados. Desde la raíz: `make sim-comparadores` o `make wave-comparadores`.

## Qué observar en GTKWave

Agrega `contador_angular`, `converseg`, `convermin`, `converhor`, `match_seg`, `match_min` y `match_hor`.

- `match_min` debe ser 1 únicamente cuando el ángulo es 64.
- `match_hor` debe ser 1 únicamente cuando el ángulo es 21.
- `match_seg` debe ser 1 únicamente cuando el ángulo es 128.
- En los demás ángulos, los tres matches deben permanecer en 0.

## Rangos y extremos

Las cuatro señales de ángulo son de 8 bits: el barrido cubre el mínimo `0` y el máximo `255`, ambos incluidos. Cada salida `match_*` solo puede ser lógica `0` o `1`; debe activarse en una única dirección coincidente y quedar apagada en las otras 255. Los valores fijos usados son segundos `128`, minutos `64` y horas `21`.

## Resultado esperado

La consola muestra `PASS: comparadores verificados para los 256 angulos`. Las tres señales verifican igualdad exacta; cualquier activación faltante o extra hace fallar la prueba.

