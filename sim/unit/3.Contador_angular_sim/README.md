# Simulación unitaria: sensor Hall y contador angular

## Qué comprueba

La prueba entrega pulsos Hall al top angular, mide el intervalo entre referencias y verifica que los pulsos de paso incrementen el ángulo. También comprueba que la referencia de una nueva vuelta reinicie el ángulo.

## Ejecutar

Desde esta carpeta: `make` compila y corre la autoevaluación; `make wave` abre `angulo.vcd`; `make clean` limpia los productos. Desde la raíz: `make sim-angular` o `make wave-angular`.

## Qué observar en GTKWave

Agrega `clk`, `rst`, `sensor_eh`, `angulo`, `dut.tick_1_4`, `dut.inicio_vuelta`, `dut.hall.medidor.periodo_total`, `dut.hall.medidor.periodo_valido` y `dut.hall.generador.periodo_paso`.

1. El primer pulso Hall establece la referencia.
2. El segundo permite medir el periodo y calcular el paso angular.
3. Cuando `periodo_valido` está activo, cada pulso `tick_1_4` incrementa `angulo` en uno.
4. La cuenta llega a 255; la siguiente referencia Hall devuelve el ángulo a 0.

## Rangos y extremos

El ángulo es de 8 bits y recorre `0–255` (256 sectores); `255` es el máximo antes del reinicio de vuelta. La prueba observa los 255 pulsos angulares posibles entre referencias y verifica la vuelta `255 → 0`. El periodo Hall se mide en ciclos de reloj de 32 bits; el test usa cerca de 5120 ciclos entre referencias, pero no prueba extremos de periodo `0` ni `2^32−1`.

## Resultado esperado

La consola informa aproximadamente 255 ticks, muestra 255 antes de la nueva referencia y 0 después. Debe terminar con `PASS: avance y reinicio angular correctos`; errores de avance o falta de pulsos producen `$fatal`.

