`timescale 1ns / 1ps

module tb_generador_manecillas;

    reg        MATCH_SEG;
    reg        MATCH_MIN;
    reg        MATCH_HORA;
    reg [31:0] ROM_OUT;

    wire [31:0] PATRON_SEG;
    wire [31:0] PATRON_MIN;
    wire [31:0] PATRON_HORA;
    wire [31:0] PATRON_MANECILLAS;
    wire [31:0] LED_OUT;

    generador_manecillas_top uut (
        .MATCH_SEG(MATCH_SEG),
        .MATCH_MIN(MATCH_MIN),
        .MATCH_HORA(MATCH_HORA),
        .ROM_OUT(ROM_OUT),
        .PATRON_SEG(PATRON_SEG),
        .PATRON_MIN(PATRON_MIN),
        .PATRON_HORA(PATRON_HORA),
        .PATRON_MANECILLAS(PATRON_MANECILLAS),
        .LED_OUT(LED_OUT)
    );

    initial begin
        $dumpfile("sim_manecillas.vcd");
        $dumpvars(0, tb_generador_manecillas);

        // Estado inicial (todo apagado)
        MATCH_SEG = 0; MATCH_MIN = 0; MATCH_HORA = 0; ROM_OUT = 32'h0;
        #10;

        // Prueba 1: Coincidencia de Segundos (debe dar 0x01FFFFFF)
        MATCH_SEG = 1; #10; MATCH_SEG = 0;

        // Prueba 2: Coincidencia de Minutos (debe dar 0x001FFFFF)
        MATCH_MIN = 1; #10; MATCH_MIN = 0;

        // Prueba 3: Coincidencia de Horas (debe dar 0x00007FFF)
        MATCH_HORA = 1; #10; MATCH_HORA = 0;

        // Prueba 4: Solapamiento simultáneo de Horas y Minutos con Carátula
        MATCH_HORA = 1; MATCH_MIN = 1; ROM_OUT = 32'h80000000; #10;

        $finish;
    end

    initial begin
        $monitor("Tiempo=%0t ns | MATCH(S,M,H)=%b%b%b | PATRON_MANECILLAS=0x%h | LED_OUT=0x%h",
                 $time, MATCH_SEG, MATCH_MIN, MATCH_HORA, PATRON_MANECILLAS, LED_OUT);
    end

endmodule
