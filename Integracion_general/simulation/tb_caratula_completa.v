
`timescale 1ns/1ps

module tb_caratula_completa;

    reg [7:0] dir_angulo = 8'd255;
    wire [3:0] caratula_out;

    reg [3:0] esperado;

    integer i;
    integer errores = 0;
    integer marcas_horas = 0;
    integer marcas_minutos = 0;
    integer posiciones_anillo = 0;

    // ROM original
    rom_caratula_256x4 dut (
        .dir_angulo(dir_angulo),
        .caratula_out(caratula_out)
    );

    // Funcion para calcular el resultado esperado
    function [3:0] patron_esperado;
        input [7:0] posicion;
        begin
            case (posicion)

                // Posiciones principales de horas
                0,1,255,21,22,42,43,
                63,64,65,85,86,106,107,
                127,128,129,149,150,
                170,171,191,192,193,
                213,214,234,235:
                    patron_esperado = 4'b1111;

                // Posiciones secundarias de minutos
                4,8,13,17,26,30,34,38,
                47,51,55,60,68,73,77,81,
                90,94,98,102,111,115,119,124,
                132,137,141,145,154,158,162,166,
                175,179,183,188,196,201,205,209,
                218,222,226,230,239,243,247,251:
                    patron_esperado = 4'b1100;

                // Anillo exterior
                default:
                    patron_esperado = 4'b1000;

            endcase
        end
    endfunction

    initial begin

        $dumpfile("caratula_completa.vcd");
        $dumpvars(0, tb_caratula_completa);

        $display("=== PRUEBA DE 256 POSICIONES ===");
        // Permitir que la ROM evalúe la dirección inicial
        #1;

        // Recorrer una vuelta completa
        for (i = 0; i < 256; i = i + 1) begin
        

            dir_angulo = i;
            esperado = patron_esperado(dir_angulo);

            #10;

            // Verificar el patron
            if (caratula_out !== esperado) begin
                $display(
                    "ERROR: angulo=%0d esperado=%b obtenido=%b",
                    i, esperado, caratula_out
                );
                errores = errores + 1;
            end

            // Contar los tipos de posiciones
            case (caratula_out)
                4'b1111:
                    marcas_horas = marcas_horas + 1;

                4'b1100:
                    marcas_minutos = marcas_minutos + 1;

                4'b1000:
                    posiciones_anillo = posiciones_anillo + 1;
            endcase

        end

        $display("=== RESULTADOS ===");

        $display("Marcas principales: %0d",
                 marcas_horas);

        $display("Marcas secundarias: %0d",
                 marcas_minutos);

        $display("Posiciones de anillo: %0d",
                 posiciones_anillo);

        $display("Errores: %0d", errores);

        if (errores == 0 &&
            marcas_horas == 28 &&
            marcas_minutos == 48 &&
            posiciones_anillo == 180)
            $display("PRUEBA SUPERADA");
        else
            $display("PRUEBA FALLIDA");

        $finish;

    end

endmodule

