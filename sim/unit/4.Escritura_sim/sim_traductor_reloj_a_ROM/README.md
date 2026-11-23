# Simulación unitaria: conversores de tiempo a ángulo

## Qué comprueba

Comprueba los conversores de segundos, minutos y horas que transforman un valor temporal en una dirección angular para la representación POV. Segundos y minutos usan `(valor * 256 + 30) / 60`; horas usan `(hora * 256 + 6) / 12`.

## Ejecutar

Desde esta carpeta: `make` compila, simula y valida cinco casos; `make wave` abre `sim_traductores.vcd`; `make clean` limpia los archivos. Desde la raíz: `make sim-conversores` o `make wave-conversores`.

## Qué observar en GTKWave

Agrega `seg_in`, `rom_seg`, `min_in`, `rom_min`, `hor_in` y `rom_hor`. En los casos de prueba deben observarse:

| Entrada seg/min | Salida angular seg/min | Hora | Salida angular hora |
|---:|---:|---:|---:|
| 0 | 0 | 1 | 21 |
| 15 | 64 | 3 | 64 |
| 30 | 128 | 6 | 128 |
| 45 | 192 | 9 | 192 |
| 59 | 252 | 12 | 256 |

La salida de horas tiene 12 bits: el valor 256 es esperado para las 12 horas y corresponde a 0 al tomar los 8 bits bajos para el ángulo circular.

## Rangos y extremos

Los rangos de uso son segundos/minutos `0–59` y hora de entrada al conversor `1–12`. En los extremos válidos, segundos/minutos producen `0` para `0` y `252` para `59`; las horas producen `21` para `1` y `256` para `12` (sus 8 bits bajos son `0`). El testbench prueba cinco puntos —`0`, `15`, `30`, `45`, `59` para segundos/minutos y `1`, `3`, `6`, `9`, `12` para horas—, no todos los valores intermedios. Entradas fuera del rango válido no se limitan automáticamente.

## Resultado esperado

La consola termina con `PASS: los tres conversores coinciden en los cinco casos`. Un valor distinto causa `$fatal`.

