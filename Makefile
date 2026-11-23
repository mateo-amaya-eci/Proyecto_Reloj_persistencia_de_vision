# codigo de makefile generado con inteligencia artificial chatgpt
.DEFAULT_GOAL := sim-all

# Simulaciones del proyecto. Ejecutar desde la carpeta raiz con `make`.
SIM_RTC          := sim/unit/1.RTC_READER_sim
SIM_RELOJ        := sim/unit/2.Contador_reloj_sim
SIM_ANGULAR      := sim/unit/3.Contador_angular_sim
SIM_CONVERSORES  := sim/unit/4.Escritura_sim/sim_traductor_reloj_a_ROM
SIM_COMPARADORES := sim/unit/4.Escritura_sim/sim_comparador
SIM_CALENDARIO   := sim/unit/4.Escritura_sim/sim_generacion_calendario
SIM_MANECILLAS   := sim/unit/4.Escritura_sim/sim_generador_manecillas
SIM_ROM          := sim/unit/5.Visualisacion/memoria_ROM_sim
SIM_INTEGRACION  := sim/integracion_general

.PHONY: help sim-rtc sim-reloj sim-angular sim-conversores sim-comparadores
.PHONY: sim-calendario sim-manecillas sim-rom sim-integracion sim-unit sim-all clean
.PHONY: wave-rtc wave-reloj wave-angular wave-conversores wave-comparadores
.PHONY: wave-calendario wave-manecillas wave-rom wave-integracion waves

help:
	@echo "Reloj con Persistencia de Vision - simulaciones disponibles"
	@echo "  make                 Ejecuta todas las pruebas e integracion"
	@echo "  make sim-unit        Ejecuta todas las pruebas unitarias"
	@echo "  make sim-all         Ejecuta unitarias e integracion"
	@echo "  make sim-rtc         Simula el lector RTC"
	@echo "  make sim-reloj       Simula el contador de reloj y calendario"
	@echo "  make sim-angular     Simula el sistema Hall y angulo"
	@echo "  make sim-conversores Simula conversores hora a ROM"
	@echo "  make sim-comparadores Simula comparadores de manecillas"
	@echo "  make sim-calendario  Simula generacion del calendario"
	@echo "  make sim-manecillas  Simula generador RGB de manecillas"
	@echo "  make sim-rom         Simula ROM de caratula"
	@echo "  make sim-integracion Simula el top completo"
	@echo "  make waves           Genera todos los VCD sin abrir GTKWave"
	@echo "  make wave-rtc        Simula RTC y abre su VCD"
	@echo "  make wave-reloj      Simula reloj y abre su VCD"
	@echo "  make wave-angular    Simula angulo y abre su VCD"
	@echo "  make wave-conversores Simula conversores y abre su VCD"
	@echo "  make wave-comparadores Simula comparadores y abre su VCD"
	@echo "  make wave-calendario Simula calendario y abre su VCD"
	@echo "  make wave-manecillas Simula RGB y abre su VCD"
	@echo "  make wave-rom        Simula ROM y abre su VCD"
	@echo "  make wave-integracion Simula integracion y abre su VCD"
	@echo "  make clean           Elimina archivos generados"

sim-rtc:
	$(MAKE) -C $(SIM_RTC) run

sim-reloj:
	$(MAKE) -C $(SIM_RELOJ) run

sim-angular:
	$(MAKE) -C $(SIM_ANGULAR) run

sim-conversores:
	$(MAKE) -C $(SIM_CONVERSORES) run

sim-comparadores:
	$(MAKE) -C $(SIM_COMPARADORES) run

sim-calendario:
	$(MAKE) -C $(SIM_CALENDARIO) run

sim-manecillas:
	$(MAKE) -C $(SIM_MANECILLAS) run

sim-rom:
	$(MAKE) -C $(SIM_ROM) run

sim-integracion:
	$(MAKE) -C $(SIM_INTEGRACION) sim

sim-unit: sim-rtc sim-reloj sim-angular sim-conversores sim-comparadores sim-calendario sim-manecillas sim-rom

sim-all: sim-unit sim-integracion

# Ejecuta todas las simulaciones para generar sus archivos .vcd.
waves: sim-all

# Ejecuta una simulacion y abre su archivo de ondas con GTKWave.
wave-rtc:
	$(MAKE) -C $(SIM_RTC) wave

wave-reloj:
	$(MAKE) -C $(SIM_RELOJ) wave

wave-angular:
	$(MAKE) -C $(SIM_ANGULAR) wave

wave-conversores:
	$(MAKE) -C $(SIM_CONVERSORES) wave

wave-comparadores:
	$(MAKE) -C $(SIM_COMPARADORES) wave

wave-calendario:
	$(MAKE) -C $(SIM_CALENDARIO) wave

wave-manecillas:
	$(MAKE) -C $(SIM_MANECILLAS) wave

wave-rom:
	$(MAKE) -C $(SIM_ROM) wave

wave-integracion:
	$(MAKE) -C $(SIM_INTEGRACION) wave

clean:
	$(MAKE) -C $(SIM_RTC) clean
	$(MAKE) -C $(SIM_RELOJ) clean
	$(MAKE) -C $(SIM_ANGULAR) clean
	$(MAKE) -C $(SIM_CONVERSORES) clean
	$(MAKE) -C $(SIM_COMPARADORES) clean
	$(MAKE) -C $(SIM_CALENDARIO) clean
	$(MAKE) -C $(SIM_MANECILLAS) clean
	$(MAKE) -C $(SIM_ROM) clean
	$(MAKE) -C $(SIM_INTEGRACION) clean
