
# =====================================================
# Makefile - Simulacion de Comparadores
# =====================================================

COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

# Directorio RTL
RTL_DIR = ../../../../rtl/4.Escritura/comparador

# Modulos RTL
RTL_SOURCES = $(wildcard $(RTL_DIR)/*.v)

# Testbench
TB = tb_comparadores_top.v

# Archivos generados
OUTPUT = sim_comparadores.vvp
WAVE = sim_comparadores.vcd

# Compilar
compile:
	$(COMPILER) -g2012 -Wall -s tb_comparadores_top -o $(OUTPUT) $(RTL_SOURCES) $(TB)

# Ejecutar
run: compile
	$(SIMULATOR) $(OUTPUT)

# Visualizar
wave: run
	$(VIEWER) $(WAVE)

# Limpiar
clean:
	rm -f $(OUTPUT) $(WAVE)

.PHONY: compile run wave clean
