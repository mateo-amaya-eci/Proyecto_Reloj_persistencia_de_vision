
// Testbench generado por IA
`timescale 1ns / 1ps

module tb_rom_caratula_256x4;

    reg  [7:0] dir_angulo;
    wire [3:0] caratula_out;

    integer angulo;

    // Modulo real: rom_caratula_256x4
    rom_caratula_256x4 uut (
        .dir_angulo(dir_angulo),
        .caratula_out(caratula_out)
    );

    initial begin
        $dumpfile("sim_rom_caratula.vcd");
        $dumpvars(0, tb_rom_caratula_256x4);

        $display("==============================================");
        $display("       SIMULACION ROM CARATULA POV");
        $display("==============================================");

        // Prueba 1: marca principal
        dir_angulo = 8'd0;
        #10;
        if (caratula_out !== 4'b1111)
            $error("ERROR angulo 0: salida=%b", caratula_out);
        else
            $display("OK: angulo 0 - marca principal");

        // Prueba 2: marca secundaria
        dir_angulo = 8'd4;
        #10;
        if (caratula_out !== 4'b1100)
            $error("ERROR angulo 4: salida=%b", caratula_out);
        else
            $display("OK: angulo 4 - marca secundaria");

        // Prueba 3: fondo
        dir_angulo = 8'd2;
        #10;
        if (caratula_out !== 4'b1000)
            $error("ERROR angulo 2: salida=%b", caratula_out);
        else
            $display("OK: angulo 2 - anillo exterior");

        // Recorrer los 256 angulos
        $display("----------------------------------------------");
        $display("Recorriendo los 256 angulos...");

        for (angulo = 0; angulo < 256; angulo = angulo + 1) begin
            dir_angulo = angulo;
            #10;
        end

        $display("----------------------------------------------");
        $display("SIMULACION FINALIZADA");
        $display("==============================================");

        $finish;
    end

endmodule
