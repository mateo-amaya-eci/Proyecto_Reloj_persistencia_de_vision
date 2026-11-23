# Simulación de integración general POV

## Qué comprueba

Esta simulación conecta el lector RTC DS1302, el reloj y calendario, el contador angular Hall, conversores de ángulo, comparadores, generador RGB, calendario gráfico y ROM de carátula. El testbench modela el RTC y el sensor Hall, y verifica las señales integradas.

## Ejecutar

Desde esta carpeta:

```sh
make          # compila, ejecuta la integración y autoevalúa resultados
make wave     # repite la simulación y abre el VCD en GTKWave
make clean    # limpia el directorio build
```

Desde la raíz del proyecto se puede ejecutar `make sim-integracion` o `make wave-integracion`. `make waves` genera las ondas de todas las pruebas sin abrir GTKWave.

## Datos y resultados esperados

El modelo DS1302 entrega: segundos `30`, minutos `15`, horas `03`, día `07`, mes `11`, día de semana `03`, año `26`. La orden transmitida debe ser `BF`. El reloj debe cargar los mismos valores en binario; por ejemplo, noviembre es 11 y el año 26.

Tras medir el periodo del sensor Hall, el ángulo debe avanzar en sectores. En las direcciones de prueba, el testbench confirma coincidencias de manecillas y calendario:

- coincidencia de hora/minuto en el ángulo 64 y segundos en el 128;
- calendario activo en los inicios de región 85 (semana), 107 (día), 128 (mes) y 149 (año);
- región sin calendario en el ángulo 200;
- canales RGB interiores iguales a la máscara de manecilla combinada con el patrón del calendario mediante OR.

## Rangos y extremos verificados

El test de integración usa un único tiempo/fecha RTC de inicio (`03:15:30`, `07/11/26`, semana `03`); no recorre el rango completo de calendario. Las señales de tiempo deben respetar segundos/minutos `0–59`, hora interna `0–23` (visualizada `1–12`), día `1–31`, mes `1–12`, año `0–99` y semana `1–7`. El ángulo cubre sectores de 8 bits, `0–255`; el test confirma regiones de calendario desde 85 hasta 170 y un punto fuera de región en 200. El recorrido del sensor usa pulsos de referencia separados por unos 5120 ciclos, no los límites extremos del contador de periodo Hall.

## Qué observar en GTKWave

El Makefile abre `build/top_pov_completo.vcd`. En el testbench busca `clk`, `reset`, `sensor_eh`, `RTC_CE`, `RTC_SCLK`, `RTC_DAT`, `angulo`, `angulo_hor`, `angulo_min`, `angulo_seg`, `match_hor`, `match_min`, `match_seg`, `led_calendario`, `led_r`, `led_g`, `led_b` y `led_caratula`. También están los registros RTC y señales internas del reloj bajo la instancia `dut`.

1. Observa la transacción de RTC y la activación de `rtc_valid`.
2. Observa los pulsos Hall: el primero fija la referencia y el siguiente habilita la medición del periodo.
3. Comprueba que el ángulo cambia por sectores y que las coincidencias generan pulsos en el canal de color correspondiente.
4. En las regiones 85–170 observa los patrones de calendario superpuestos en los cinco LED interiores; fuera de ellas deben quedar apagados.
5. La ROM controla `led_caratula[3:0]` de forma independiente.

## Resultado esperado

La consola termina con `EXITO: TOP POV COMPLETO INTEGRADO CORRECTAMENTE`, todas las banderas de prueba en 1 y cero errores de conexión OR. El testbench usa `$fatal` ante errores o timeout, por lo que Make devuelve un estado fallido si la integración no cumple.

