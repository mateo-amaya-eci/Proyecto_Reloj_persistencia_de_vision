`timescale 1ns / 1ps

module tb_rom_caratula_256x32;

    reg  [7:0]  dir_angulo;
    wire [31:0] caratula_out;

    // Instancia de la memoria ROM bajo prueba (UUT)
    rom_caratula_256x32 uut (
        .dir_angulo(dir_angulo),
        .caratula_out(caratula_out)
    );

    initial begin
        // Archivo de ondas VCD para GTKWave
        $dumpfile("sim_rom_caratula.vcd");
        $dumpvars(0, tb_rom_caratula_256x32);

        $display("=========================================================================");
        $display("          PRUEBA DE MEMORIA ROM CARÁTULA 256x32 (SILUETA DE RELOJ)       ");
        $display("=========================================================================");

        dir_angulo = 8'd0;
        #10;

        repeat (255) begin
            dir_angulo = dir_angulo + 8'd1;
            #10;
        end

        $display("=========================================================================");
        $display("Simulación de la ROM completada con éxito.");
        $finish;
    end

endmodule