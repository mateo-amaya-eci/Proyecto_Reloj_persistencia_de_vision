IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

RTL_DIR = rtl
SIM_DIR = simulation

DESIGN = $(wildcard $(RTL_DIR)/*.v)
TESTBENCH = $(SIM_DIR)/tb_rtc_reader.v

OUTPUT = $(SIM_DIR)/sim_rtc_reader
WAVE = $(SIM_DIR)/rtc_reader.vcd

# Compilar el diseño completo
compile:
	$(IVERILOG) -g2012 -Wall -s tb_rtc_reader -o $(OUTPUT) $(DESIGN) $(TESTBENCH)

# Ejecutar la simulación
run: compile
	$(VVP) $(OUTPUT)

# Abrir las formas de onda
wave: run
	$(GTKWAVE) $(WAVE)

# Limpiar archivos generados
clean:
	rm -f $(OUTPUT) $(WAVE)

.PHONY: compile run wave clean