# Nombre del compilador y visualizador
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

# Únicos archivos fuente que tienes en la carpeta
SRC = lectura.v lectura_datos_tb.v

# Regla por defecto: compila y ejecuta
all: clean compile run

# Compilación con Icarus Verilog
compile:
	$(COMPILER) -o sim.vvp $(SRC)

# Ejecución de la simulación para generar el archivo VCD
run:
	$(SIMULATOR) sim.vvp

# Abrir las formas de onda en GTKWave
wave:
	$(VIEWER) sim_out.vcd &

# Limpiar archivos generados
clean:
	rm -f sim.vvp sim_out.vcd