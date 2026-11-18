# Makefile para el calendario POV

IVERILOG ?= iverilog
VVP ?= vvp
GTKWAVE ?= gtkwave

RTL_DIR := rtl
SIM_DIR := simulation
TB := $(SIM_DIR)/tb_generacion_calendario.v
SIM_OUT := $(SIM_DIR)/calendario_sim
VCD := $(SIM_DIR)/calendario.vcd

RTL := \
	$(RTL_DIR)/bin_to_bcd.v \
	$(RTL_DIR)/decodificador_BCD_3col.v \
	$(RTL_DIR)/decodificador_numero_2digitos.v \
	$(RTL_DIR)/decodificador_semana.v \
	$(RTL_DIR)/detector_regiones.v \
	$(RTL_DIR)/mux_onehot_regiones.v \
	$(RTL_DIR)/selector_columnas.v \
	$(RTL_DIR)/generacion_calendario.v

.PHONY: compile sim wave clean

compile:
	mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2012 -Wall -s tb_generacion_calendario -o $(SIM_OUT) $(RTL) $(TB)

sim: compile
	$(VVP) $(SIM_OUT)

wave: sim
	$(GTKWAVE) $(VCD)

clean:
	rm -f $(SIM_OUT) $(VCD)
