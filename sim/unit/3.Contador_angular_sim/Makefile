
# =====================================================
# Makefile - Sistema Hall + Contador Angular
# =====================================================

COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

# Directorios RTL
HALL_DIR = ../../../rtl/3.Generar_pulso_por_grado
TOP_DIR = ../../../rtl/3.Generar_pulso_por_grado

# Modulos necesarios para el TOP
RTL_SOURCES = \
	$(HALL_DIR)/sistema_hall.v \
	$(HALL_DIR)/contador_angular.v \
	$(TOP_DIR)/top_angulo.v

# Testbench del TOP
TB = tb_top_angulo.v

# Archivos generados
OUTPUT = sim_top_angulo.vvp
WAVE = angulo.vcd

# Compilar TOP
compile:
	$(COMPILER) -g2012 -Wall -s tb_top_angulo -o $(OUTPUT) $(RTL_SOURCES) $(TB)

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
