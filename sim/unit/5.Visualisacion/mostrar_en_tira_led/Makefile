IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

RTL_DIR = ../../../../rtl
RTL = \
	$(RTL_DIR)/6.Visualisacion/mostrar\ en\ tira\ led/integracion_leds.v \
	$(RTL_DIR)/4.Escritura/comparador/comparadores_top.v \
	$(RTL_DIR)/4.Escritura/comparador/comparador_seg.v \
	$(RTL_DIR)/4.Escritura/comparador/comparador_min.v \
	$(RTL_DIR)/4.Escritura/comparador/comparador_hor.v \
	$(RTL_DIR)/4.Escritura/generador_manecillas/generador_manecillas_rgb.v \
	$(RTL_DIR)/6.Visualisacion/memoria_ROM/rom_caratula_256x4.v

TB = tb_integracion_leds.v

OUTPUT = sim_integracion_leds.vvp
VCD = sim_integracion_leds.vcd

.PHONY: compile run wave clean

compile:
	$(IVERILOG) -g2012 -Wall -s tb_integracion_leds -o $(OUTPUT) $(RTL) $(TB)

run: compile
	$(VVP) $(OUTPUT)

wave: run
	$(GTKWAVE) $(VCD)

clean:
	rm -f $(OUTPUT) $(VCD)
