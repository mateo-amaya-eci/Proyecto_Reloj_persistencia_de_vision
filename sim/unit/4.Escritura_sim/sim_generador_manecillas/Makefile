
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

RTL_DIR = ../../../../rtl/4.Escritura/generador_manecillas

TB_MANECILLAS = tb_generador_manecillas.v
TB_RGB = tb_generador_manecillas_rgb.v

RTL_MANECILLAS = $(RTL_DIR)/generador_manecillas.v
RTL_RGB = $(RTL_DIR)/generador_manecillas_rgb.v

OUT_MANECILLAS = sim_manecillas.vvp
OUT_RGB = sim_rgb.vvp

VCD_MANECILLAS = sim_manecillas.vcd
VCD_RGB = sim_rgb.vcd

.PHONY: all compile run compile_manecillas run_manecillas compile_rgb run_rgb wave_manecillas wave_rgb clean

all: run

compile: compile_manecillas compile_rgb

run: run_manecillas run_rgb

compile_manecillas:
	$(IVERILOG) -g2012 -Wall -s tb_generador_manecillas -o $(OUT_MANECILLAS) $(RTL_MANECILLAS) $(TB_MANECILLAS)

run_manecillas: compile_manecillas
	$(VVP) $(OUT_MANECILLAS)

compile_rgb:
	$(IVERILOG) -g2012 -Wall -s tb_generador_manecillas_rgb -o $(OUT_RGB) $(RTL_RGB) $(TB_RGB)

run_rgb: compile_rgb
	$(VVP) $(OUT_RGB)

wave_manecillas: run_manecillas
	$(GTKWAVE) $(VCD_MANECILLAS)

wave_rgb: run_rgb
	$(GTKWAVE) $(VCD_RGB)

clean:
	rm -f $(OUT_MANECILLAS) $(OUT_RGB) $(VCD_MANECILLAS) $(VCD_RGB)
