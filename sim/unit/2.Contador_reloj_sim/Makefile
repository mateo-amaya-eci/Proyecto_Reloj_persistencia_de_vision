
# =====================================================
# Makefile - Simulacion del reloj_top
# =====================================================

COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

# Directorio RTL
RTL_DIR = ../../../rtl/2.Contador_reloj

# Testbench
TB = tb_reloj_top.v

# Modulos RTL
RTL_SOURCES = $(wildcard $(RTL_DIR)/*.v)

# Archivos generados
OUTPUT = reloj_sim.vvp
WAVE = reloj_top.vcd

.DEFAULT_GOAL := run

# Compilar
compile:
	$(COMPILER) -g2012 -Wall -s tb_reloj_top -o $(OUTPUT) $(RTL_SOURCES) $(TB)

# Ejecutar simulacion
run: compile
	$(SIMULATOR) $(OUTPUT)

# Abrir formas de onda
wave: run
	$(VIEWER) $(WAVE)

# Limpiar
clean:
	rm -f $(OUTPUT) $(WAVE)

.PHONY: compile run wave clean
