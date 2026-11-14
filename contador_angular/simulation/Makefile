# Makefile for simulating the contador angular module
#codigo generado por  IA
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

RTL = ../rtl

SRC = $(RTL)/contador_angular.v

TB = tb_contador_angular.v

all: compile run

compile:
	$(COMPILER) -g2012 -o contador_sim $(SRC) $(TB)

run:
	$(SIMULATOR) contador_sim

wave:
	$(VIEWER) contador_angular.vcd

clean:
	rm -f contador_sim contador_angular.vcd
