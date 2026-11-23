
# Reloj con Persistencia de Visión (POV)

## 1. Introducción

El reloj con sistema de **Persistencia de Visión (POV)** es un proyecto que busca representar un reloj analógico mediante una secuencia de luces LED en movimiento. Gracias a la rotación del sistema y al efecto de persistencia de visión del ojo humano, se genera una imagen que permite visualizar las manecillas, los números de la fecha y el día de la semana.

El proyecto utiliza una FPGA como unidad principal de procesamiento, integrando conceptos de electrónica digital mediante circuitos secuenciales y combinacionales. Estos permiten coordinar la información del tiempo con la posición angular del sistema para formar la imagen del reloj durante su movimiento.

## 2. Objetivos y requisitos

El proyecto se desarrolla teniendo en cuenta los siguientes requisitos establecidos para su implementación:

- **Representación de la hora:** mostrar la hora en formato analógico o digital.
- **Visualización del día:** representar el día correspondiente de la semana.
- **Uso de colores:** emplear al menos tres colores para diferenciar los elementos de la imagen.

## 3. Descripción general de la solución

Para cumplir con los requisitos planteados, se propone un sistema que utiliza un sensor Hall para detectar cada revolución del mecanismo. A partir de esta señal, la FPGA determina el tiempo de giro y coordina la actualización de la imagen proyectada.

Cada revolución se divide en **256 posiciones angulares**, lo que permite representar la imagen mediante incrementos aproximados de 1,4°. De manera paralela, un sistema de conteo mantiene actualizada la información del reloj, incluyendo la hora y la fecha.

Finalmente, la información temporal y la posición angular se combinan para determinar qué luces LED deben activarse en cada instante del giro. De esta manera, se forma la imagen del reloj mediante el efecto de persistencia de visión.



## 4. Arquitectura general e implementación

La arquitectura del sistema se organiza en **tres bloques funcionales principales**: generación de la posición angular, adquisición y actualización del tiempo, y generación de la imagen. Estos bloques  se integran en la FPGA para producir la visualización del reloj mediante persistencia de visión.

### 4.1. Generación de la posición angular

El módulo `TOP_angulo` utiliza un sensor de efecto Hall para detectar cada revolución del sistema y medir el periodo de giro. A partir de esta medición, divide cada revolución en **256 posiciones angulares**, donde cada posición representa aproximadamente 1,4°.

El resultado es un contador angular de 8 bits que sirve como referencia para sincronizar la activación de los LED con el movimiento del sistema.

### 4.2. Adquisición y actualización del tiempo

El módulo `RTC_READER` se encarga de obtener la hora y fecha iniciales mediante el RTC DS1302. La comunicación se controla mediante una máquina de estados finitos (FSM), que gestiona la transmisión de comandos y la recepción de los datos seriales.

Los datos recibidos se almacenan en registros y se utilizan para inicializar los contadores internos de la FPGA. Posteriormente, estos mantienen actualizados los segundos, minutos, horas y campos del calendario, permitiendo disponer de la información temporal necesaria para la visualización.

### 4.3. Generación de la imagen y visualización

La generación de la imagen utiliza la posición angular y la información temporal para controlar dos procesos principales:

- **Representación de las manecillas:** los valores de segundos, minutos y horas se convierten en posiciones angulares y se comparan con el contador angular. Cuando coinciden, se activan los LED RGB correspondientes, utilizando diferentes colores para distinguir cada manecilla.

- **Representación del calendario:** la fecha y el día de la semana se organizan en regiones angulares específicas. Mediante matrices de representación y lógica combinacional, se determina qué LED deben encenderse para mostrar los números y el día correspondiente.

Finalmente, las señales de ambos procesos se integran para controlar los **10 LED RGB**. Adicionalmente, una memoria ROM genera las señales de cuatro LED independientes que representan la circunferencia y las marcas de referencia de la carátula.

De esta manera, la posición angular sincroniza la representación de las manecillas, el calendario y la carátula, formando la imagen completa del reloj mediante persistencia de visión.

## 5. Estructura del repositorio

El repositorio está organizado de forma modular para facilitar la comprensión, modificación y verificación del sistema. El código fuente se encuentra separado de los archivos de simulación y configuración.

```text
Proyecto_Reloj_persistencia_de_vision/
│
├── rtl/
│   ├── 1. RTC_READER/
│   ├── 2.Contador_reloj/
│   ├── 3.Generar_pulso_por_grado/
│   ├── 4.Escritura/
│   ├── 6.Visualisacion/
│   └── Integracion_general/
│
├── sim/
│   ├── unit/
│   │   ├── 1.RTC_READER_sim/
│   │   ├── 2.Contador_reloj_sim/
│   │   ├── 3.Contador_angular_sim/
│   │   ├── 4.Escritura_sim/
│   │   └── 5.Visualisacion/
│   │
│   └── integracion_general/
│
├── docs/
│
├── Makefile
├── pinout_top_pov_completo.cst
├── reloj_timing.sdc
└── .gitignore
```

### Descripción de los directorios

| Directorio o archivo | Descripción |
|---|---|
| `rtl/` | Contiene los módulos Verilog que conforman el sistema. Está organizado según las diferentes etapas funcionales del proyecto. |
| `sim/unit/` | Contiene las pruebas unitarias para verificar el funcionamiento de los módulos individuales. |
| `sim/integracion_general/` | Contiene los archivos relacionados con la simulación del sistema completo. |
| `docs/` | Directorio destinado a la documentación y los diagramas del proyecto. |
| `Makefile` | Permite ejecutar y organizar las simulaciones mediante comandos desde la terminal. |
| `pinout_top_pov_completo.cst` | Define la asignación de pines de la FPGA para las entradas y salidas del sistema. |
| `reloj_timing.sdc` | Contiene las restricciones de temporización del diseño. |


### Organización de las simulaciones

El proyecto cuenta con Makefiles individuales para cada entorno de simulación, encargados de definir los procesos de compilación, ejecución, visualización de señales y limpieza de archivos generados.

Adicionalmente, se dispone de un **Makefile principal en la raíz del repositorio**, que centraliza estos procesos y permite ejecutar las diferentes pruebas sin necesidad de ingresar a cada directorio. De esta manera, es posible ejecutar las simulaciones unitarias, la simulación de integración o todas las pruebas mediante comandos desde la carpeta principal.

## 6. Simulación y verificación

Las simulaciones se gestionan mediante **GNU Make**, utilizando Icarus Verilog para la compilación y ejecución de los testbenches, y GTKWave para visualizar las formas de onda.

### Ejecución desde el directorio principal

Desde la raíz del repositorio se encuentran disponibles los siguientes comandos:

| Comando | Función |
|---|---|
| `make` | Ejecuta todas las pruebas unitarias y la simulación de integración. |
| `make sim-all` | Ejecuta todas las simulaciones del proyecto. |
| `make sim-unit` | Ejecuta las simulaciones unitarias. |
| `make sim-integracion` | Ejecuta la simulación del sistema completo. |
| `make waves` | Ejecuta todas las simulaciones y genera los archivos de ondas `.vcd`. |
| `make clean` | Elimina los archivos generados durante las simulaciones. |
| `make help` | Muestra los comandos disponibles. |

### Simulaciones individuales

También es posible ejecutar cada entorno de simulación de manera independiente:

| Comando | Módulo o sistema |
|---|---|
| Comando | Módulo o sistema | Guía de simulación |
|---|---|---|
| `make sim-rtc` | Lector del RTC DS1302. | [README](sim/unit/1.RTC_READER_sim/README.md) |
| `make sim-reloj` | Contadores de tiempo y calendario. | [README](sim/unit/2.Contador_reloj_sim/README.md) |
| `make sim-angular` | Detección Hall y generación de posición angular. | [README](sim/unit/3.Contador_angular_sim/README.md) |
| `make sim-conversores` | Conversores de tiempo a posiciones de representación. | [README](sim/unit/4.Escritura_sim/sim_traductor_reloj_a_ROM/README.md) |
| `make sim-comparadores` | Comparadores de las manecillas. | [README](sim/unit/4.Escritura_sim/sim_comparador/README.md) |
| `make sim-calendario` | Generación de la representación del calendario. | [README](sim/unit/4.Escritura_sim/sim_generacion_calendario/README.md) |
| `make sim-manecillas` | Generación RGB de las manecillas. | [README](sim/unit/4.Escritura_sim/sim_generador_manecillas/README.md) |
| `make sim-rom` | Memoria ROM de la carátula. | [README](sim/unit/5.Visualisacion/memoria_ROM_sim/README.md) |
| `make sim-integracion` | Sistema completo. | [README](sim/integracion_general/README.txt) |

### Visualización de resultados

Los resultados de las simulaciones pueden visualizarse mediante GTKWave. Para ello, el Makefile principal dispone de comandos individuales que ejecutan la prueba correspondiente y abren su archivo de formas de onda.

Por ejemplo:

```bash
make wave-rtc
make wave-angular
make wave-integracion
```

Los archivos de simulación generados utilizan el formato `.vcd`, que permite analizar el comportamiento de las señales digitales a lo largo del tiempo.


## 7. Descripción de los módulos principales

El diseño está desarrollado mediante módulos Verilog independientes, organizados según su función dentro del sistema. Esta estructura facilita la integración, simulación y verificación de cada bloque.

| Módulo | Función principal |
|---|---|
| `top_pov_completo` | Módulo principal que integra los diferentes bloques del reloj y conecta sus señales de entrada y salida. |
| `rtc_reader` | Gestiona la comunicación con el RTC DS1302 y obtiene los datos iniciales de hora y fecha. |
| `reloj_top` | Administra los contadores internos encargados de mantener actualizada la hora y el calendario. |
| `top_angulo` | Coordina la detección del sensor Hall y la generación de la referencia de posición angular. |
| `generacion_calendario` | Procesa la información de la fecha y genera las señales para representar el calendario. |
| `generador_manecillas_rgb` | Genera las señales de control RGB para representar las manecillas del reloj. |
| `rom_caratula_256x4` | Almacena el patrón de activación de los cuatro LED independientes que forman la carátula del reloj. |

Estos módulos se complementan con bloques auxiliares encargados de realizar conversiones numéricas, comparaciones, conteos, divisiones de frecuencia y almacenamiento de información.

## 8. Hardware Planteado

Para el desarrollo del proyecto se contemplaron los siguientes componentes:

| Componente | Función |
|---|---|
| **Tang Nano 9K (FPGA)** | Procesamiento y control de la lógica digital del sistema. |
| **RTC DS1302** | Suministro de la información de hora y fecha. |
| **Sensor Hall HW-484** | Detección de cada revolución del sistema. |
| **10 LED RGB** | Representación de las manecillas y el calendario. |
| **4 LED independientes** | Representación de la carátula y sus marcas de referencia. |
| **Motorreductor DC** | Generación del movimiento giratorio del sistema. |
| **Módulo XKT412-01** | Propuesta de alimentación inalámbrica para la FPGA durante la rotación. |

El diseño también contempló una alimentación externa para el motor y una alternativa de transferencia inalámbrica de energía para la parte móvil.


## 9. Herramientas de desarrollo

Para el desarrollo, simulación y programación del proyecto se utilizaron las siguientes herramientas:

| Herramienta | Uso |
|---|---|
| **Icarus Verilog** | Compilación y ejecución de las simulaciones de los módulos Verilog. |
| **GTKWave** | Visualización y análisis de las señales generadas durante las simulaciones. |
| **Gowin EDA** | Síntesis del diseño, asignación de pines y programación de la FPGA Tang Nano 9K. |
| **WSL (Windows Subsystem for Linux)** | Entorno Linux utilizado para ejecutar las herramientas de simulación y gestionar el proyecto. |

El código fuente está desarrollado en Verilog y no depende directamente de WSL. Por tanto, puede trabajarse desde otros sistemas operativos que cuenten con las herramientas y configuraciones necesarias.

## 10. Configuración y programación de la FPGA

El diseño está dirigido a la FPGA **Tang Nano 9K** y se implementa utilizando Gowin EDA. Para configurar el proyecto se deben agregar los archivos Verilog del directorio `rtl/` y establecer `top_pov_completo` como módulo principal (*Top Module*).

El repositorio incluye los siguientes archivos de configuración:

- `pinout_top_pov_completo.cst`: define la asignación de pines físicos de la FPGA para las señales de entrada y salida del sistema.
- `reloj_timing.sdc`: establece la restricción de temporización del reloj principal de 27 MHz, correspondiente a un periodo aproximado de 37,037 ns.

Una vez configurado el proyecto, se ejecuta la síntesis y la implementación del diseño en Gowin EDA. Finalmente, se genera el archivo de programación y se carga en la FPGA mediante la herramienta Programmer del entorno.
## 11. Uso de herramientas de IA

Durante el desarrollo del proyecto se utilizó ChatGPT como herramienta de apoyo para el diseño, implementación, verificación y documentación del sistema.

Su utilización incluyó las siguientes actividades:

- **Generación de código Verilog:** se utilizó como apoyo para implementar módulos a partir de la lógica y los esquemáticos previamente planteados por los integrantes del proyecto. También se empleó para la generación del módulo `RTC_READER`.
- **Diseño y planteamiento de lógica:** se consultaron alternativas para resolver problemas de diseño, organizar la arquitectura de algunos módulos y definir estrategias de implementación.
- **Revisión de código:** se compartieron módulos desarrollados por los integrantes para verificar su funcionamiento, identificar posibles errores y proponer correcciones.
- **Verificación y automatización:** se utilizó para generar los testbenches de los módulos y los archivos Makefile empleados para organizar y ejecutar las simulaciones.
- **Documentación:** se empleó como apoyo para mejorar la redacción y organización del README y otros textos relacionados con el proyecto.

Las decisiones de diseño, el planteamiento de la arquitectura y la integración de los diferentes bloques fueron responsabilidad de los integrantes del proyecto. El código generado o modificado con asistencia de IA fue revisado y adaptado durante el proceso de desarrollo.
## Integrantes del proyecto
- **Mateo Felipe Amaya Novoa**
- **Paula Alejandra Morales**
