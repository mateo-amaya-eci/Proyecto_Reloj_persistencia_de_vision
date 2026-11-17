
`timescale 1ns/1ps

module tb_top_hora_angulos;

    reg clk = 0;
    reg reset = 1;

    // Hora inicial: 3:15:58
    reg [7:0] rtc_seconds = 8'h58;
    reg [7:0] rtc_minutes = 8'h15;
    reg [7:0] rtc_hours   = 8'h03;

    reg [7:0] rtc_day     = 8'h17;
    reg [7:0] rtc_month   = 8'h11;
    reg [7:0] rtc_weekday = 8'h02;
    reg [7:0] rtc_year    = 8'h26;

    reg rtc_valid = 0;

    wire [11:0] rom_h;
    wire [13:0] rom_m;
    wire [13:0] rom_s;

    // Reloj de 10 ns
    always #5 clk = ~clk;

    // Instancia principal
    top_hora_angulos #(
        .CLK_FREQ(4)
    ) dut (
        .clk(clk),
        .reset(reset),

        .rtc_seconds(rtc_seconds),
        .rtc_minutes(rtc_minutes),
        .rtc_hours(rtc_hours),
        .rtc_day(rtc_day),
        .rtc_month(rtc_month),
        .rtc_weekday(rtc_weekday),
        .rtc_year(rtc_year),
        .rtc_valid(rtc_valid),

        .rom_h(rom_h),
        .rom_m(rom_m),
        .rom_s(rom_s)
    );

    // Mostrar los resultados
    task mostrar_hora;
    begin
        $display("Hora: %0d:%0d:%0d",
            dut.horas_visualizacion,
            dut.minutos,
            dut.segundos);

        $display("Angulos: H=%0d M=%0d S=%0d",
            rom_h, rom_m, rom_s);
    end
    endtask

    initial begin

        $dumpfile("hora_angulos.vcd");
        $dumpvars(0, tb_top_hora_angulos);

        // Reinicio inicial
        repeat (3) @(negedge clk);
        reset = 0;

        // Cargar los datos del RTC
        @(negedge clk);
        rtc_valid = 1;

        @(negedge clk);
        rtc_valid = 0;

        #1;
        $display("=== HORA INICIAL ===");
        mostrar_hora();

        // Esperar hasta 3:15:59
        wait(dut.segundos == 6'd59);
        @(negedge clk);

        $display("=== CAMBIO DE SEGUNDO ===");
        mostrar_hora();

        // Esperar hasta 3:16:00
        wait(dut.minutos == 6'd16);
        @(negedge clk);

        $display("=== CAMBIO DE MINUTO ===");
        mostrar_hora();

        // Comprobacion automatica
        if (dut.horas_visualizacion == 3 &&
            dut.minutos == 16 &&
            dut.segundos == 0 &&
            rom_h == 64 &&
            rom_m == 68 &&
            rom_s == 0)
            $display("PRUEBA SUPERADA");
        else
            $display("ERROR EN CAMBIO DE MINUTO");

        #20;
        $finish;
    end

    // Evitar simulaciones infinitas
    initial begin
        #10000;
        $display("ERROR: tiempo de espera agotado");
        $finish;
    end

endmodule
