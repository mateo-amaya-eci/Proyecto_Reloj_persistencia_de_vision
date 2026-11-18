
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Directorio de los módulos RTL
RTL_DIR = ../../../rtl/1. RTC_READER

# Directorio local de simulación
SIM_DIR = simulation

# Testbench
TESTBENCH = tb_rtc_reader.v

# Ejecutable y archivo de ondas
OUTPUT = sim_rtc_reader.vvp
WAVE = $(SIM_DIR)/rtc_reader.vcd

# Buscar todos los módulos Verilog del RTC
RTL_SOURCES = $(shell find "$(RTL_DIR)" -maxdepth 1 -type f -name '*.v' -print0 | xargs -0 -r printf '"%s" ')

# Crear carpeta de simulación
$(SIM_DIR):
	mkdir -p $(SIM_DIR)

# Compilar
compile: $(SIM_DIR)
	$(IVERILOG) -g2012 -Wall -s tb_rtc_reader -o $(OUTPUT) $(RTL_SOURCES) $(TESTBENCH)

# Ejecutar
run: compile
	$(VVP) $(OUTPUT)

# Abrir formas de onda
wave: run
	$(GTKWAVE) $(WAVE)

# Limpiar archivos generados
clean:
	rm -f $(OUTPUT) $(WAVE)

.PHONY: compile run wave clean
