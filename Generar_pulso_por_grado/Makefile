COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

SRC = sistema_hall.v sistema_hall_tb.v

all: clean compile run

compile:
	$(COMPILER) -o sim_hall.vvp $(SRC)

run:
	$(SIMULATOR) sim_hall.vvp

wave:
	$(VIEWER) sim_hall.vcd &

clean:
	rm -f sim_hall.vvp sim_hall.vcd