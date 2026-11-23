# Simulación unitaria: generador RGB de manecillas

## Qué comprueba

Verifica las máscaras RGB activadas por coincidencia angular de segundos, minutos y horas, tanto por separado como simultáneamente.

## Ejecutar

Desde esta carpeta: `make` compila el RTL presente y autoevalúa cinco combinaciones; `make wave` abre `sim_rgb.vcd`; `make clean` limpia resultados. Desde la raíz: `make sim-manecillas` o `make wave-manecillas`.

## Qué observar en GTKWave

Agrega `MATCH_SEG`, `MATCH_MIN`, `MATCH_HORA`, `LED_R[9:0]`, `LED_G[9:0]`, `LED_B[9:0]`.

- Todo apagado: R/G/B = 0.
- Segundos: rojo = `1111111111`.
- Minutos: azul = `0011111111`.
- Horas: verde = `0000011111`.
- Coincidencia triple: las tres máscaras aparecen simultáneamente.

En estas máscaras, los LED de índice bajo corresponden a los cinco LED interiores; por eso la máscara de horas ocupa cinco bits y la de minutos ocho.

## Rangos y extremos

Cada entrada `MATCH_*` es de un bit (`0` apagada o `1` activa). Cada salida RGB es de 10 bits y sus valores extremos son todo apagado `0000000000` y la máscara máxima del canal: rojo `1111111111`, verde `0000011111`, azul `0011111111`. La prueba cubre apagado, cada manecilla individual y las tres activas; no barre las otras combinaciones parciales posibles.

## Resultado esperado

La consola muestra `PASS: patrones RGB correctos`. Un patrón inesperado produce `$fatal`.

