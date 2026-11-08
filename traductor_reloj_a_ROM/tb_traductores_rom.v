`timescale 1ns / 1ps

module tb_traductores_rom;

    // 1. Señales de prueba (Entradas)
    reg [5:0] seg_in;
    reg [5:0] min_in;
    reg [3:0] hor_in;

    // 2. Cables de salida de los traductores
    wire [13:0] rom_seg;
    wire [13:0] rom_min;
    wire [11:0] rom_hor;

    // 3. Instanciación de los tres conversores
    conversor_segundos inst_seg (
        .salida_s(seg_in),
        .rom_s(rom_seg)
    );

    conversor_minutos inst_min (
        .salida_m(min_in),
        .rom_m(rom_min)
    );

    conversor_horas inst_hor (
        .salida_h(hor_in),
        .rom_h(rom_hor)
    );

    // 4. Secuencia de prueba y monitoreo
    initial begin
        $dumpfile("sim_traductores.vcd");
        $dumpvars(0, tb_traductores_rom);

        $display("=========================================================================");
        $display("          PRUEBA DE TRADUCTORES RELOJ A ROM (SEGUNDOS, MINUTOS, HORAS)   ");
        $display("=========================================================================");
        $display(" Tiempo(ns) | Seg_in -> ROM_Seg | Min_in -> ROM_Min | Hor_in -> ROM_Hor ");
        $display("-------------------------------------------------------------------------");

        $monitor(" %9t  |   %2d   ->   %3d   |   %2d   ->   %3d   |   %2d   ->   %3d",
                 $time, seg_in, rom_seg, min_in, rom_min, hor_in, rom_hor);

        // Caso 1: Valores iniciales en 0 (Seg/Min = 0, Hora = 1)
        seg_in = 6'd0;
        min_in = 6'd0;
        hor_in = 4'd1;
        #10;

        // Caso 2: Cuarto de escala (15 seg, 15 min, 3 horas)
        seg_in = 6'd15;
        min_in = 6'd15;
        hor_in = 4'd3;
        #10;

        // Caso 3: Media escala (30 seg, 30 min, 6 horas)
        seg_in = 6'd30;
        min_in = 6'd30;
        hor_in = 4'd6;
        #10;

        // Caso 4: Tres cuartos de escala (45 seg, 45 min, 9 horas)
        seg_in = 6'd45;
        min_in = 6'd45;
        hor_in = 4'd9;
        #10;

        // Caso 5: Valores máximos (59 seg, 59 min, 12 horas)
        seg_in = 6'd59;
        min_in = 6'd59;
        hor_in = 4'd12;
        #10;

        $display("=========================================================================");
        $display("Simulación completada con éxito.");
        $finish;
    end

endmodule