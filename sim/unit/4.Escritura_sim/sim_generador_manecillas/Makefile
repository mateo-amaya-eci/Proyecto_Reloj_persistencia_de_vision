IVERILOG ?= iverilog
VVP ?= vvp
GTKWAVE ?= gtkwave

RTL_DIR := ../../../../rtl/4.Escritura/generador_manecillas
RTL := $(RTL_DIR)/generador_manecillas_rgb.v
TB := tb_generador_manecillas_rgb.v
OUTPUT := sim_rgb.vvp
WAVE := sim_rgb.vcd

.DEFAULT_GOAL := run
.PHONY: all compile run wave clean

all: run

compile:
	$(IVERILOG) -g2012 -Wall -s tb_generador_manecillas_rgb -o $(OUTPUT) $(RTL) $(TB)

run: compile
	$(VVP) $(OUTPUT)

wave: run
	$(GTKWAVE) $(WAVE)

clean:
	rm -f $(OUTPUT) $(WAVE)
