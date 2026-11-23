# Simulación unitaria: generador de calendario POV

## Qué comprueba

Barre dos vueltas completas (ángulos 0 a 255) con una fecha fija: 15/11/26 y código de día de semana 6. Comprueba que el calendario esté apagado fuera de su ventana angular y que sus salidas no contengan valores desconocidos dentro de ella.

## Ejecutar

Desde esta carpeta: `make` ejecuta la prueba; `make wave` abre `simulation/calendario.vcd`; `make clean` limpia los archivos generados. Desde la raíz: `make sim-calendario` o `make wave-calendario`.

## Qué observar en GTKWave

Agrega `AN`, `DIA_SEMANA`, `DIA`, `MES`, `ANO` y `LED[4:0]`.

- Para ángulos 0–84 y 171–255, `LED` debe ser `00000`.
- La ventana de calendario es 85–170 inclusive.
- En la ventana, `LED` debe estar definido (sin X). El patrón recorre las representaciones del día de semana, día, mes y año según la posición angular.
- Los límites de región visibles son 85/106 para semana, 107/127 para día, 128/148 para mes y 149/170 para año.

## Rangos y extremos

La entrada angular cubre `0–255`. El calendario está habilitado solo en `85–170` inclusive; por tanto, `84` y `171` son los extremos vecinos que deben permanecer apagados. Las subregiones son semana `85–106`, día `107–127`, mes `128–148` y año `149–170`. El test recorre ambos extremos de la dirección angular y verifica apagado fuera de la ventana y salida definida dentro. Sus datos de calendario son día `15`, mes `11`, año `26`, semana `6`; el barrido no prueba todos los valores posibles de fecha.

## Resultado esperado

La consola recorre dos vueltas y termina con `PASS: regiones del calendario definidas y fuera de rango apagadas`. El testbench comprueba límites y valores definidos; no compara aquí cada columna con una fuente tipográfica de referencia.

