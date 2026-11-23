# Simulación unitaria: reloj y calendario

## Qué comprueba

Verifica la carga inicial desde datos BCD del RTC, la conversión de hora de 24 a 12 horas, el avance de segundos y los acarreos al cruzar medianoche y cambiar de año. El divisor se configura con `CLK_FREQ=4` para acelerar la simulación; no representa un segundo real de FPGA.

## Ejecutar

Desde esta carpeta: `make` ejecuta compilación, simulación y comprobaciones. `make wave` abre `reloj_top.vcd` en GTKWave; `make clean` limpia los resultados. Desde la raíz: `make sim-reloj` o `make wave-reloj`.

## Qué observar en GTKWave

Agrega `clk`, `reset`, `rtc_valid`, `uut.tick_1s`, `uut.tick_seg`, `uut.tick_min`, `uut.tick_dia`, `uut.load_inicial`, `uut.horas`, `segundos`, `minutos`, `horas_visualizacion`, `dia`, `semana`, `mes` y `anio`.

- La carga inicial debe producir 23:59:58 del 31/12/24, semana 7; en formato de 12 horas se ve 11:59:58.
- Primer tick: 23:59:59. Solo avanza el segundo.
- Segundo tick: 00:00:00; la fecha pasa a 01/01/25 y la semana a 1. El acarreo se propaga desde segundos hasta año.
- Tercer tick: 00:00:01.

## Rangos y extremos

Los contadores deben permanecer en segundos/minutos `0–59`, horas internas `0–23` (visualización de 12 h `1–12`), día `1–31`, mes `1–12`, año `0–99` y semana `1–7`. La prueba arranca en `23:59:58` del `31/12/24`, avanza por el extremo `59` y cruza a `00:00:00` del `01/01/25`; comprueba segundos, minutos, horas, día, mes, año y semana. Este es un caso de frontera, no un barrido exhaustivo de todos los valores.

## Resultado esperado

La consola imprime PASS para carga, primer tick, acarreo de medianoche y estado final. Cualquier diferencia genera `$fatal`, por lo que `make` devuelve código distinto de cero.

