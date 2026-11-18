IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave


RTL_DIR = ../../../../rtl/6.Visualisacion/memoria_ROM

RTL = $(RTL_DIR)/rom_caratula_256x4.v
TB = tb_rom_caratula_256x32.v

OUTPUT = sim_rom_caratula.vvp
VCD = sim_rom_caratula.vcd

.PHONY: compile run wave clean

compile:
	$(IVERILOG) -g2012 -Wall -s tb_rom_caratula_256x4 -o $(OUTPUT) $(RTL) $(TB)

run: compile
	$(VVP) $(OUTPUT)

wave: run
	$(GTKWAVE) $(VCD)

clean:
	rm -f $(OUTPUT) $(VCD)
