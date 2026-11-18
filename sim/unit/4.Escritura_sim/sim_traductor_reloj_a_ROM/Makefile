
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

RTL_DIR = ../../../../rtl/4.Escritura/traductor_reloj_a_ROM

TB = tb_traductores_rom.v

RTL = \
	$(RTL_DIR)/conversor_segundos.v \
	$(RTL_DIR)/conversor_minutos.v \
	$(RTL_DIR)/conversor_horas.v

OUTPUT = sim_traductores.vvp
VCD = sim_traductores.vcd

.PHONY: compile run wave clean

compile:
	$(IVERILOG) -g2012 -Wall -s tb_traductores_rom -o $(OUTPUT) $(RTL) $(TB)

run: compile
	$(VVP) $(OUTPUT)

wave: run
	$(GTKWAVE) $(VCD)

clean:
	rm -f $(OUTPUT) $(VCD)
