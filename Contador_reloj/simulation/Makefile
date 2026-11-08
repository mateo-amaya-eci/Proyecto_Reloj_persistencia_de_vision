COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

RTL = ../rtl

SRC = $(RTL)/reloj_top.v \
      $(RTL)/bcd_a_binario.v \
      $(RTL)/contador_generico.v \
      $(RTL)/divisor_segundo.v \
      $(RTL)/control_calendario.v

TB = tb_reloj_top.v

all: compile run

compile:
	$(COMPILER) -g2012 -o reloj_sim $(SRC) $(TB)

run:
	$(SIMULATOR) reloj_sim

wave:
	$(VIEWER) reloj_top.vcd

clean:
	rm -f reloj_sim reloj_top.vcd