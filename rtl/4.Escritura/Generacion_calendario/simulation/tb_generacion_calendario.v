
`timescale 1ns / 1ps

module tb_generacion_calendario;

    // =====================================
    // 1. SEÑALES DEL TESTBENCH
    // =====================================

    reg clk;
    reg [7:0] AN;

    reg [2:0] DIA_SEMANA;
    reg [6:0] DIA;
    reg [6:0] MES;
    reg [6:0] ANO;

    wire [4:0] LED;

    integer vuelta;
    integer angulo;

    // =====================================
    // 2. INSTANCIA DEL SISTEMA
    // =====================================

    generacion_calendario DUT (

        .an(AN),

        .dia_semana(DIA_SEMANA),
        .dia(DIA),
        .mes(MES),
        .ano(ANO),

        .led(LED)

    );

    // =====================================
    // 3. GENERADOR DE RELOJ
    // =====================================

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // =====================================
    // 4. MONITOREO DE SEÑALES
    // =====================================

    initial begin

        $dumpfile("simulation/calendario.vcd");

        $dumpvars(0, tb_generacion_calendario);

        $display("-----------------------------------------");
        $display(" SIMULACION DEL CALENDARIO POV");
        $display("-----------------------------------------");

        $display("Fecha: 15/11/26");
        $display("Dia de semana: Domingo");
        $display("-----------------------------------------");

        $monitor(
            "Tiempo=%0t | AN=%03d | LED=%05b",
            $time, AN, LED
        );

    end

    // =====================================
    // 5. INICIALIZACION DE DATOS
    // =====================================

    initial begin

        AN = 8'd0;

        // Domingo = 6 (codificacion 1..7: lunes..domingo)
        DIA_SEMANA = 3'd6;

        // Fecha estatica: 15/11/26
        DIA = 7'd15;
        MES = 7'd11;
        ANO = 7'd26;

        // =================================
        // 6. DOS VUELTAS ANGULARES
        // =================================

        for (vuelta = 0; vuelta < 2; vuelta = vuelta + 1) begin

            $display("");
            $display("=========================================");
            $display("INICIO DE VUELTA %0d", vuelta + 1);
            $display("=========================================");

            for (angulo = 0; angulo < 256; angulo = angulo + 1) begin

                @(negedge clk);

                AN = angulo;

            end

        end

        // =================================
        // 7. FINALIZACION
        // =================================

        @(negedge clk);

        $display("");
        $display("-----------------------------------------");
        $display("SIMULACION FINALIZADA");
        $display("Dos vueltas angulares completadas");
        $display("-----------------------------------------");

        $finish;

    end

endmodule
