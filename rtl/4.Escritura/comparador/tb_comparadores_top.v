`timescale 1ns / 1ps

module tb_comparadores_top;

    reg  [7:0] converseg;
    reg  [7:0] convermin;
    reg  [7:0] converhor;
    reg  [7:0] contador_angular;

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

        // Recorrer el contador angular de 0 a 255
        contador_angular = 8'd0;
        #10;

        // Probar barrido angular
        repeat (256) begin
            #10;
            contador_angular = contador_angular + 8'd1;
        end

        $finish;
    end

    initial begin
        $monitor("Tiempo = %0t ns | Angulo = %3d | Match_Seg = %b | Match_Min = %b | Match_Hor = %b",
                 $time, contador_angular, match_seg, match_min, match_hor);
    end

endmodule
