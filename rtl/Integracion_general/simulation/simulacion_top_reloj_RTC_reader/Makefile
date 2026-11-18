COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

RTL = ../../rtl
RTC = ../../../RTC_READER/rtl
RELOJ = ../../../Contador_reloj/rtl
CONV = ../../../traductor_reloj_a_ROM
COMP = ../../../comparador
HALL = ../../../Generar_pulso_por_grado
ANG = ../../../contador_angular

SRC = \
	$(RTL)/top_reloj_RTC_integrado.v \
	$(RTL)/top_reloj_integrado.v \
	$(RTL)/top_hora_angulos.v \
	$(RTL)/top_angulo.v \
	$(RTC)/rtc_reader.v \
	$(RTC)/generador_clk.v \
	$(RTC)/transmisor_rtc.v \
	$(RTC)/receptor_sipo.v \
	$(RTC)/contador_bytes.v \
	$(RTC)/contador_bits.v \
	$(RTC)/banco_registros_rtc.v \
	$(RTC)/controlador_rtc.v \
	$(RTC)/control_fase.v \
	$(RTC)/contador_divisor.v \
	$(RELOJ)/reloj_top.v \
	$(RELOJ)/divisor_segundo.v \
	$(RELOJ)/contador_generico.v \
	$(RELOJ)/bcd_a_binario.v \
	$(RELOJ)/control_calendario.v \
	$(RELOJ)/contador_calendario.v \
	$(RELOJ)/contador_anio.v \
	$(RELOJ)/contador_mes.v \
	$(RELOJ)/contador_semana.v \
	$(RELOJ)/contador_dia.v \
	$(CONV)/conversor_horas.v \
	$(CONV)/conversor_minutos.v \
	$(CONV)/conversor_segundos.v \
	$(COMP)/comparadores_top.v \
	$(COMP)/comparador_seg.v \
	$(COMP)/comparador_min.v \
	$(COMP)/comparador_hor.v \
	$(HALL)/sistema_hall.v \
	$(ANG)/rtl/contador_angular.v

TB = tb_top_reloj_RTC_integrado.v

OUTPUT = sim_top_reloj_RTC_integrado.vvp
WAVE = top_reloj_RTC_integrado.vcd

all: clean compile run

compile:
	$(COMPILER) -g2012 -s tb_top_reloj_RTC_integrado -o $(OUTPUT) $(SRC) $(TB)

run:
	$(SIMULATOR) $(OUTPUT)

wave:
	$(VIEWER) $(WAVE) &

clean:
	rm -f $(OUTPUT) $(WAVE)

.PHONY: all compile run wave clean
