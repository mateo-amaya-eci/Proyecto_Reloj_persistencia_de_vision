# Simulacion del top POV completo con Icarus Verilog.
# Ejecutar desde esta carpeta con: make sim

IVERILOG ?= iverilog
VVP      ?= vvp
GTKWAVE  ?= gtkwave

RTL  := ../../rtl
BUILD := build
SIM   := $(BUILD)/sim_top_pov_completo.vvp

TOP := $(RTL)/Integracion_general/rtl/top_pov_completo.v
TB  := tb_top_pov_completo.v

.DEFAULT_GOAL := all
.PHONY: all compile sim run wave gtkwave clean

all: sim

compile:
	mkdir -p $(BUILD)
	$(IVERILOG) -g2012 -Wall -s tb_top_pov_completo -o $(SIM) \
		"$(RTL)/1. RTC_READER/"*.v \
		$(RTL)/2.Contador_reloj/*.v \
		$(RTL)/3.Generar_pulso_por_grado/*.v \
		$(RTL)/4.Escritura/traductor_reloj_a_ROM/*.v \
		$(RTL)/4.Escritura/comparador/*.v \
		$(RTL)/4.Escritura/generador_manecillas/generador_manecillas_rgb.v \
		$(RTL)/4.Escritura/Generacion_calendario/*.v \
		$(RTL)/6.Visualisacion/memoria_ROM/rom_caratula_256x4.v \
		$(TOP) \
		$(TB)
sim: compile
	cd $(BUILD) && $(VVP) sim_top_pov_completo.vvp

run: sim

wave: sim
	cd $(BUILD) && $(GTKWAVE) top_pov_completo.vcd

gtkwave: wave

clean:
	rm -rf $(BUILD)
