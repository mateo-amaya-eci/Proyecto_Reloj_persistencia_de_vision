
# =====================================================
# Makefile - Generacion de Calendario POV
# =====================================================

IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Directorio de los modulos RTL
RTL_DIR = ../../../../rtl/4.Escritura/Generacion_calendario

# Testbench
TB = tb_generacion_calendario.v

# Archivos generados
SIM_DIR = simulation
SIM_OUT = calendario_sim.vvp
VCD = $(SIM_DIR)/calendario.vcd

# Modulos RTL
RTL = $(wildcard $(RTL_DIR)/*.v)

# Compilar
compile:
	mkdir -p $(SIM_DIR)
	$(IVERILOG) -g2012 -Wall -s tb_generacion_calendario -o $(SIM_OUT) $(RTL) $(TB)

# Ejecutar
run: compile
	$(VVP) $(SIM_OUT)

# Alias para simular
sim: run

# Abrir formas de onda
wave: run
	$(GTKWAVE) $(VCD)

# Limpiar
clean:
	rm -f $(SIM_OUT) $(VCD)

.PHONY: compile run sim wave clean
