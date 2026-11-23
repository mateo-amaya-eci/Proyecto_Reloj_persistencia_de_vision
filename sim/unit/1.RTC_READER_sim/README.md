# Simulación unitaria: lector RTC DS1302

## Qué comprueba

El testbench simula el DS1302 y comprueba que el lector envíe el comando de lectura por ráfaga `BF`, reciba 8 bytes LSB primero y guarde correctamente los siete campos de hora y fecha. El byte de control se recibe, pero no se almacena.

## Ejecutar

Desde esta carpeta:

```sh
make          # compila, simula y comprueba los resultados
make wave     # vuelve a simular y abre simulation/rtc_reader.vcd en GTKWave
make clean    # elimina ejecutable y VCD
```

Desde la raíz también se puede usar `make sim-rtc` o `make wave-rtc`. Se requiere Icarus Verilog; para `make wave`, también GTKWave.

## Qué observar en GTKWave

Agrega `clk`, `reset`, `RTC_CE`, `RTC_SCLK`, `RTC_DAT`, `command_received`, `command_bits`, `data_bit_index`, `rtc_valid` y los registros `seconds`, `minutes`, `hours`, `day`, `month`, `weekday`, `year`.

1. `reset` empieza activo y después se libera.
2. `RTC_CE` sube para iniciar una transacción. Tras el retardo de inicio comienza `RTC_SCLK`.
3. En `RTC_DAT` se transmite `BF`; el testbench lo reconstruye en `command_received`.
4. El modelo presenta los datos en este orden: segundos `56`, minutos `34`, horas `12`, día `07`, mes `11`, día de semana `03`, año `26` y control `00`.
5. Al completar la ráfaga, `rtc_valid` sube y los siete registros conservan esos valores en hexadecimal BCD.

## Rangos y extremos

El testbench usa un único conjunto de datos; no barre todos los límites. Los rangos funcionales BCD del DS1302 para este diseño son segundos y minutos `00–59`, horas `00–23` (formato 24 h), día `01–31`, mes `01–12`, día de semana `01–07` y año `00–99`. El byte de control es adicional y se descarta. El caso probado está dentro de esos rangos: `56:34:12`, `07/11/26`, semana `03`.

En el bus serial, la trama probada tiene un comando de 8 bits (`BF`) y 8 bytes de respuesta (64 bits). El receptor debe completar la transacción antes del timeout del testbench; una lectura incompleta no es válida aunque algunos registros coincidan.

## Resultado esperado

La consola debe mostrar `EXITO: todos los registros son correctos` y `EXITO: comando BF transmitido correctamente`. Si el comando, algún byte o el tiempo límite falla, la simulación termina con `$fatal` y Make devuelve error.

