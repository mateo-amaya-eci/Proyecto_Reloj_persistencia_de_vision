// TestBench Generado por IA
`timescale 1ns / 1ps

module tb_comparadores_top;

    reg  [7:0] converseg;
    reg  [7:0] convermin;
    reg  [7:0] converhor;
    reg  [7:0] contador_angular;
    integer i;
    integer errores = 0;

    wire       match_seg;
    wire       match_min;
    wire       match_hor;

    // Instancia del módulo TOP
    comparadores_top uut (
        .converseg(converseg),
        .convermin(convermin),
        .converhor(converhor),
        .contador_angular(contador_angular),
        .match_seg(match_seg),
        .match_min(match_min),
        .match_hor(match_hor)
    );

    initial begin
        $dumpfile("sim_comparadores.vcd");
        $dumpvars(0, tb_comparadores_top);

        // Caso 1: Definir posiciones fijas para los conversores (Ej: Seg=128, Min=64, Hor=256/21)
        converseg = 8'd128; // 30 segundos mapeados a ángulo
        convermin = 8'd64;  // 15 minutos mapeados a ángulo
        converhor = 8'd21;  // 1 hora mapeada a ángulo

        // Verificar que cada comparador solo se activa en su angulo.
        for (i = 0; i < 256; i = i + 1) begin
            contador_angular = i[7:0];
            #1;
            if (match_seg !== (i == 128)) errores = errores + 1;
            if (match_min !== (i == 64)) errores = errores + 1;
            if (match_hor !== (i == 21)) errores = errores + 1;
        end

        if (errores != 0)
            $fatal(1, "FAIL: %0d comparaciones incorrectas", errores);
        $display("PASS: comparadores verificados para los 256 angulos");
        $finish;
    end

    initial begin
        $monitor("Tiempo = %0t ns | Angulo = %3d | Match_Seg = %b | Match_Min = %b | Match_Hor = %b",
                 $time, contador_angular, match_seg, match_min, match_hor);
    end

endmodule
