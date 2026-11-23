# Simulación unitaria: ROM de carátula

## Qué comprueba

Valida los patrones de referencia de la carátula y barre todas las 256 direcciones para comprobar que la salida de 4 bits esté definida.

## Ejecutar

Desde esta carpeta: `make` ejecuta la autoevaluación; `make wave` abre `sim_rom_caratula.vcd`; `make clean` limpia los resultados. Desde la raíz: `make sim-rom` o `make wave-rom`.

## Qué observar en GTKWave

Agrega `dir_angulo[7:0]` y `caratula_out[3:0]`.

- Dirección 0: `1111`, marca principal.
- Dirección 2: `1000`, anillo exterior.
- Dirección 4: `1100`, marca secundaria.
- El resto de direcciones debe producir un patrón definido. Las marcas horarias y secundarias se repiten alrededor de la vuelta; el valor por defecto representa el anillo.

## Rangos y extremos

La dirección de la ROM es de 8 bits y se prueba completa: `0–255`. La salida tiene 4 bits, así que su rango binario es `0000–1111`; en esta ROM el anillo por defecto es `1000`, las marcas secundarias son `1100` y las principales `1111`. Las direcciones extremas `0` y `255` son marcas principales. El test verifica los puntos `0`, `2`, `4` y que ninguna dirección entregue X; no compara la tabla completa contra un patrón esperado en cada dirección.

## Resultado esperado

La consola muestra los tres mensajes `OK` de referencia y termina con `PASS: puntos de referencia correctos y ROM definida en 256 angulos`. Un valor X o referencia incorrecta hace fallar la simulación.

