# Reloj con Persistencia de Visión (POV)

## 1. Introducción

El reloj con sistema de **Persistencia de Visión (POV)** es un proyecto que busca representar un reloj mediante una secuencia de luces LED en movimiento. Gracias a la rotación del sistema y al efecto de persistencia de visión del ojo humano, se busca generar una imagen que permita visualizar las manecillas, los números de la fecha y el día de la semana.

El proyecto utiliza una FPGA como unidad principal de procesamiento e integra conceptos de electrónica digital mediante circuitos secuenciales y combinacionales. Estos permiten coordinar la información del tiempo con la posición angular del sistema para generar la representación visual del reloj.

El desarrollo se centra en el diseño de la arquitectura digital, la descripción de los módulos en Verilog y su verificación mediante simulaciones.

> **Nota:** No fue posible completar el montaje experimental debido a dificultades con el sistema motriz y la iluminación de los LED, que no lograron funcionar como se esperaba. Por esta razón, el desarrollo se limitó al diseño lógico y a la verificación mediante simulaciones digitales.

## 2. Objetivos y requisitos

El proyecto se desarrolla teniendo en cuenta los siguientes requisitos:

- **Representación de la hora:** mostrar la hora mediante una representación analógica.
- **Visualización del día:** representar el día correspondiente de la semana.
- **Uso de colores:** emplear al menos tres colores para diferenciar los elementos de la imagen.

## 3. Descripción general de la solución

La solución digital propuesta utiliza un sensor Hall para detectar cada revolución del mecanismo. A partir de esta señal, la FPGA determina la referencia de giro y coordina la actualización de la imagen.

Cada revolución se divide en **256 posiciones angulares**, lo que permite representar la imagen mediante incrementos aproximados de 1,4°. De manera paralela, un sistema de conteo mantiene actualizada la información del reloj, incluyendo la hora y la fecha.

Finalmente, la información temporal y la posición angular se combinan para determinar qué luces LED deben activarse en cada instante del giro. De esta manera, se obtiene la lógica necesaria para formar la imagen del reloj mediante persistencia de visión.

## 4. Arquitectura general e implementación

La arquitectura del sistema se organiza en tres bloques funcionales principales: generación de la posición angular, adquisición y actualización del tiempo, y generación de la imagen. Estos bloques se integran en la FPGA para producir la visualización del reloj mediante persistencia de visión.

### 4.1. Generación de la posición angular

El módulo `top_angulo` utiliza un sensor de efecto Hall para detectar cada revolución del sistema y medir el periodo de giro. A partir de esta medición, divide cada revolución en **256 posiciones angulares**, donde cada posición representa aproximadamente 1,4°.

El resultado es un contador angular de 8 bits que sirve como referencia para sincronizar la activación de los LED con el movimiento del sistema.

### 4.2. Adquisición y actualización del tiempo

El módulo `RTC_READER` se encarga de obtener la hora y fecha iniciales mediante el RTC DS1302. La comunicación se controla mediante una máquina de estados finitos (FSM), que gestiona la transmisión de comandos y la recepción de los datos seriales.

Los datos recibidos se almacenan en registros y se utilizan para inicializar los contadores internos de la FPGA. Posteriormente, estos mantienen actualizados los segundos, minutos, horas y campos del calendario, permitiendo disponer de la información temporal necesaria para la visualización.

### 4.3. Generación de la imagen y visualización

La generación de la imagen utiliza la posición angular y la información temporal para controlar dos procesos principales:

- **Representación de las manecillas:** los valores de segundos, minutos y horas se convierten en posiciones angulares y se comparan con el contador angular. Cuando coinciden, se activan los LED RGB correspondientes, utilizando diferentes colores para distinguir cada manecilla.

- **Representación del calendario:** la fecha y el día de la semana se organizan en regiones angulares específicas. Mediante matrices de representación y lógica combinacional, se determina qué LED deben encenderse para mostrar los números y el día correspondiente.

Finalmente, las señales de ambos procesos se integran para controlar los **10 LED RGB**. Adicionalmente, una memoria ROM genera las señales de cuatro LED independientes que representan la circunferencia y las marcas de referencia de la carátula.

De esta manera, la posición angular sincroniza la representación de las manecillas, el calendario y la carátula, formando la lógica necesaria para generar la imagen completa del reloj mediante persistencia de visión.

## 5. Estructura del repositorio

El repositorio está organizado de forma modular para facilitar la comprensión, modificación y verificación del sistema. El código fuente se encuentra separado de los archivos de simulación, configuración y documentación.

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
│   │   │   ├── sim_traductor_reloj_a_ROM/
│   │   │   ├── sim_comparador/
│   │   │   ├── sim_generacion_calendario/
│   │   │   └── sim_generador_manecillas/
│   │   └── 5.Visualisacion/
│   │       └── memoria_ROM_sim/
│   │
│   └── integracion_general/
│
├── constrains/
│   ├── pinout_top_pov_completo.cst
│   └── reloj_timing.sdc
│
├── docs/
│   ├── datacheets/
│   ├── diagramas/
│   └── impl/       
│
├── informe/
│   └── proyecto_final_digitales.pdf
│
├── Makefile
├── README.md
└── .gitignore
```

### Descripción de los directorios

| Directorio o archivo       | Descripción                                                                                            |
| -------------------------- | ------------------------------------------------------------------------------------------------------ |
| `rtl/`                     | Contiene los módulos Verilog que conforman el sistema.                                                 |
| `sim/unit/`                | Contiene las pruebas unitarias utilizadas para verificar los módulos individuales.                     |
| `sim/integracion_general/` | Contiene los archivos relacionados con la simulación del sistema completo.                             |
| `constrains/`              | Almacena los archivos de configuración de la FPGA y las restricciones de temporización.                |
| `docs/diagramas/`          | Contiene los diagramas y representaciones gráficas de la arquitectura.                                 |
| `docs/datacheets/`         | Contiene las hojas de datos de los componentes considerados para el proyecto.                          |
| `docs/impl/`               | Almacena archivos y reportes generados durante los procesos de síntesis e implementación en Gowin EDA. |
| `informe/`                 | Contiene el documento del informe final del proyecto.                                                  |
| `Makefile`                 | Permite ejecutar y organizar las simulaciones mediante comandos desde la terminal.                     |
| `README.md`                | Presenta la descripción general, arquitectura y organización del repositorio.                          |

### Archivos de restricciones

Dentro de `constrains/` se encuentran dos archivos importantes para la configuración del diseño:

- `pinout_top_pov_completo.cst`: define la asignación de pines físicos de la FPGA para las señales de entrada y salida del sistema.
- `reloj_timing.sdc`: establece las restricciones de temporización del reloj principal de 27 MHz, correspondiente a un periodo aproximado de 37,037 ns.

Estos archivos permiten establecer las condiciones necesarias para la síntesis e implementación del diseño en la FPGA Tang Nano 9K.

## 6. Simulación y verificación

La verificación del diseño se realiza mediante simulaciones digitales, utilizando **Icarus Verilog** para la compilación y ejecución de los testbenches, y **GTKWave** para visualizar las formas de onda.

El proyecto cuenta con pruebas unitarias para los diferentes bloques funcionales y una prueba de integración que permite observar el comportamiento conjunto del sistema.

### Ejecución desde el directorio principal

Desde la raíz del repositorio se encuentran disponibles los siguientes comandos:

| Comando                | Función                                                             |
| ---------------------- | ------------------------------------------------------------------- |
| `make`                 | Ejecuta todas las pruebas unitarias y la simulación de integración. |
| `make sim-all`         | Ejecuta todas las simulaciones del proyecto.                        |
| `make sim-unit`        | Ejecuta las simulaciones unitarias.                                 |
| `make sim-integracion` | Ejecuta la simulación del sistema completo.                         |
| `make waves`           | Ejecuta las simulaciones y genera los archivos de ondas `.vcd`.     |
| `make clean`           | Elimina los archivos generados durante las simulaciones.            |
| `make help`            | Muestra los comandos disponibles.                                   |

### Simulaciones individuales

También es posible ejecutar cada entorno de simulación de manera independiente:

| Comando                 | Módulo o sistema                                      |
| ----------------------- | ----------------------------------------------------- |
| `make sim-rtc`          | Lector del RTC DS1302.                                |
| `make sim-reloj`        | Contadores de tiempo y calendario.                    |
| `make sim-angular`      | Detección Hall y generación de posición angular.      |
| `make sim-conversores`  | Conversores de tiempo a posiciones de representación. |
| `make sim-comparadores` | Comparadores de las manecillas.                       |
| `make sim-calendario`   | Generación de la representación del calendario.       |
| `make sim-manecillas`   | Generación RGB de las manecillas.                     |
| `make sim-rom`          | Memoria ROM de la carátula.                           |
| `make sim-integracion`  | Sistema completo.                                     |

### Visualización de resultados de simulación

Los resultados de las simulaciones pueden visualizarse mediante GTKWave. Para ello, el Makefile principal dispone de comandos individuales que ejecutan la prueba correspondiente y abren su archivo de formas de onda.

Por ejemplo:

```bash
make wave-rtc
make wave-angular
make wave-integracion
```

Los archivos generados utilizan el formato `.vcd`, que permite analizar el comportamiento de las señales digitales a lo largo del tiempo.

## 7. Descripción de los módulos principales

El diseño está desarrollado mediante módulos Verilog independientes, organizados según su función dentro del sistema. Esta estructura facilita la integración, simulación y verificación de cada bloque.

| Módulo                     | Función principal                                                                                        |
| -------------------------- | -------------------------------------------------------------------------------------------------------- |
| `top_pov_completo`         | Módulo principal que integra los diferentes bloques del reloj y conecta sus señales de entrada y salida. |
| `rtc_reader`               | Gestiona la comunicación con el RTC DS1302 y obtiene los datos iniciales de hora y fecha.                |
| `reloj_top`                | Administra los contadores internos encargados de mantener actualizada la hora y el calendario.           |
| `top_angulo`               | Coordina la detección del sensor Hall y la generación de la referencia de posición angular.              |
| `generacion_calendario`    | Procesa la información de la fecha y genera las señales para representar el calendario.                  |
| `generador_manecillas_rgb` | Genera las señales de control RGB para representar las manecillas del reloj.                             |
| `rom_caratula_256x4`       | Almacena el patrón de activación de los cuatro LED independientes que forman la carátula del reloj.      |

Estos módulos se complementan con bloques auxiliares encargados de realizar conversiones numéricas, comparaciones, conteos, divisiones de frecuencia y almacenamiento de información.

## 8. Hardware considerado para el proyecto

Para el diseño del sistema se contemplaron los siguientes componentes:

| Componente               | Función prevista                                                                           |
| ------------------------ | ------------------------------------------------------------------------------------------ |
| **Tang Nano 9K (FPGA)**  | Procesamiento y control de la lógica digital del sistema.                                  |
| **RTC DS1302**           | Suministro de la información de hora y fecha.                                              |
| **Sensor Hall HW-484**   | Detección de cada revolución del sistema.                                                  |
| **10 LED RGB**           | Representación de las manecillas y el calendario.                                          |
| **4 LED independientes** | Representación de la carátula y sus marcas de referencia.                                  |
| **Motorreductor DC**     | Generación del movimiento giratorio del sistema.                                           |
| **Módulo XKT412-01**     | Alternativa contemplada para la transferencia inalámbrica de energía hacia la parte móvil. |

Los componentes anteriores corresponden al hardware considerado en el planteamiento del proyecto. No se completó el montaje experimental del sistema.

## 9. Herramientas de desarrollo

Para el desarrollo, simulación y programación del proyecto se utilizaron las siguientes herramientas:

| Herramienta                           | Uso                                                                                                    |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| **Icarus Verilog**                    | Compilación y ejecución de las simulaciones de los módulos Verilog.                                    |
| **GTKWave**                           | Visualización y análisis de las señales generadas durante las simulaciones.                            |
| **Gowin EDA**                         | Síntesis del diseño, asignación de pines y preparación de la implementación para la FPGA Tang Nano 9K. |
| **WSL (Windows Subsystem for Linux)** | Entorno Linux utilizado para ejecutar las herramientas de simulación y gestionar el proyecto.          |

El código fuente está desarrollado en Verilog y no depende directamente de WSL. Por tanto, puede trabajarse desde otros sistemas operativos que cuenten con las herramientas y configuraciones necesarias.

## 10. Configuración de la FPGA

El diseño está dirigido a la FPGA **Tang Nano 9K** y se plantea su implementación utilizando Gowin EDA. Para configurar el proyecto se deben agregar los archivos Verilog del directorio `rtl/` y establecer `top_pov_completo` como módulo principal (*Top Module*).

El repositorio incluye los siguientes archivos de configuración dentro de `constrains/`:

- `pinout_top_pov_completo.cst`: define la asignación de pines físicos de la FPGA para las señales de entrada y salida del sistema.
- `reloj_timing.sdc`: establece la restricción de temporización del reloj principal de 27 MHz, correspondiente a un periodo aproximado de 37,037 ns.

Estos archivos forman parte de la configuración necesaria para los procesos de síntesis e implementación del diseño.

## 11. Declaración de uso de herramientas de inteligencia artificial

Durante el desarrollo del proyecto se utilizó **ChatGPT, desarrollado por OpenAI**, como herramienta de apoyo en diferentes etapas de planificación, diseño, implementación, verificación y documentación.

El uso de esta herramienta tuvo como propósito complementar el trabajo de los integrantes, facilitar la resolución de dificultades técnicas y apoyar la organización del proyecto. Su participación se puede describir en las siguientes actividades:

### 11.1. Planeación y organización de la arquitectura

Se consultó ChatGPT para analizar alternativas de organización del sistema, establecer una división funcional de la arquitectura y orientar la integración de los diferentes bloques digitales.

Estas consultas sirvieron como apoyo para evaluar estrategias de diseño y ordenar las etapas de desarrollo. Sin embargo, las decisiones finales sobre la metodología de trabajo, la organización de los módulos y el enfoque de implementación fueron tomadas por los integrantes del proyecto.

### 11.2. Desarrollo del módulo RTC_READER

La principal excepción en cuanto a la participación de la inteligencia artificial en la generación de código corresponde al módulo `RTC_READER`.

Para este módulo se utilizó asistencia considerable de ChatGPT durante su construcción. El proceso se realizó de manera iterativa: los integrantes establecieron los requerimientos, plantearon las necesidades de funcionamiento, revisaron las respuestas obtenidas y proporcionaron retroalimentación para ajustar progresivamente el diseño.

La herramienta apoyó la generación y estructuración de partes del código relacionadas con la comunicación con el RTC DS1302, la máquina de estados finitos, el control de transmisión y recepción de datos, los contadores y los registros internos.

### 11.3. Diseño de los demás módulos digitales

A excepción del módulo `RTC_READER`, los integrantes desarrollaron y probaron sus propios diseños digitales. La metodología de diseño, el planteamiento de la lógica y la construcción de los módulos fueron realizados por el equipo.

La inteligencia artificial se utilizó únicamente como apoyo puntual para resolver dudas, recibir orientaciones sobre posibles soluciones y revisar aspectos específicos de los diseños. Estas orientaciones no reemplazaron el proceso de análisis, desarrollo y prueba realizado por los integrantes.

Por tanto, la metodología empleada para el diseño de los demás bloques digitales corresponde al trabajo propio del equipo.

### 11.4. Revisión y depuración de código

Se compartieron fragmentos de código y descripciones de errores con ChatGPT para recibir apoyo en la identificación de posibles fallos, analizar comportamientos inesperados y proponer correcciones.

Las sugerencias se utilizaron como referencia durante la depuración. Los integrantes revisaron los cambios y determinaron cuáles eran pertinentes para el funcionamiento de cada módulo.

### 11.5. Generación de testbenches y Makefiles

ChatGPT también se utilizó como apoyo para la elaboración de algunos testbenches y archivos Makefile. Estos recursos facilitaron la automatización de las simulaciones unitarias y de integración, así como la ejecución de pruebas y la visualización de señales mediante GTKWave.

Los archivos fueron incorporados al repositorio y ajustados a la estructura de directorios y necesidades del proyecto.

### 11.6. Apoyo en la documentación técnica

La herramienta se utilizó para mejorar la claridad y organización de textos técnicos a partir de ideas, explicaciones y contenido proporcionado por los integrantes. Este apoyo incluyó la revisión de redacción, la estructuración de descripciones de módulos y la organización de la documentación del repositorio.

El contenido técnico y las decisiones que se describen en los documentos corresponden al trabajo desarrollado por el equipo.

### 11.7. Responsabilidad del trabajo

Los integrantes del proyecto son responsables del planteamiento, las decisiones de diseño, el desarrollo de los módulos digitales —con la excepción de la asistencia considerable recibida en `RTC_READER`—, la integración, las pruebas y la revisión de los resultados obtenidos mediante simulación.

ChatGPT fue utilizado como una herramienta de apoyo y consulta, no como sustituto de la participación ni de la responsabilidad académica de los integrantes.

## 12. Integrantes del proyecto

- **Mateo Felipe Amaya Novoa**
- **Paula Alejandra Morales**
