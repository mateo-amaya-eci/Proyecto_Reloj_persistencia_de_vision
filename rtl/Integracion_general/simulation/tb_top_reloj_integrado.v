
`timescale 1ns/1ps

module tb_top_reloj_integrado;

    reg clk = 0;
    reg reset = 1;
    reg sensor_eh = 0;

    // Hora simulada: 3:15:30
    reg [7:0] rtc_seconds = 8'h30;
    reg [7:0] rtc_minutes = 8'h15;
    reg [7:0] rtc_hours   = 8'h03;

    reg [7:0] rtc_day     = 8'h17;
    reg [7:0] rtc_month   = 8'h11;
    reg [7:0] rtc_weekday = 8'h02;
    reg [7:0] rtc_year    = 8'h26;

    reg rtc_valid = 0;

    wire [7:0] angulo;
    wire [7:0] angulo_hor;
    wire [7:0] angulo_min;
    wire [7:0] angulo_seg;

    wire match_hor;
    wire match_min;
    wire match_seg;

    reg prueba_64 = 0;
    reg prueba_128 = 0;
    integer errores = 0;

    // Reloj de 10 ns
    always #5 clk = ~clk;

    // Integracion completa
    top_reloj_integrado #(
        .CLK_FREQ(27000000)
    ) dut (
        .clk(clk),
        .reset(reset),
        .sensor_eh(sensor_eh),

        .rtc_seconds(rtc_seconds),
        .rtc_minutes(rtc_minutes),
        .rtc_hours(rtc_hours),
        .rtc_day(rtc_day),
        .rtc_month(rtc_month),
        .rtc_weekday(rtc_weekday),
        .rtc_year(rtc_year),
        .rtc_valid(rtc_valid),

        .angulo(angulo),
        .angulo_hor(angulo_hor),
        .angulo_min(angulo_min),
        .angulo_seg(angulo_seg),

        .match_hor(match_hor),
        .match_min(match_min),
        .match_seg(match_seg)
    );

    // Simular el paso del iman
    task pulso_hall;
    begin
        sensor_eh = 1;
        repeat (4) @(negedge clk);
        sensor_eh = 0;
    end
    endtask

    // Comprobar las coincidencias
    always @(negedge clk) begin

        if (!reset) begin

            if (angulo == 8'd64) begin

                if (match_hor && match_min && !match_seg) begin
                    prueba_64 = 1;
                end
                else begin
                    errores = errores + 1;
                end

            end

            if (angulo == 8'd128) begin

                if (match_seg && !match_hor && !match_min) begin
                    prueba_128 = 1;
                end
                else begin
                    errores = errores + 1;
                end

            end

        end

    end

    initial begin

        $dumpfile("reloj_integrado.vcd");
        $dumpvars(0, tb_top_reloj_integrado);

        // Reinicio inicial
        repeat (5) @(negedge clk);
        reset = 0;

        // Cargar la hora desde el RTC
        @(negedge clk);
        rtc_valid = 1;

        @(negedge clk);
        rtc_valid = 0;

        // Primera deteccion Hall
        pulso_hall();

        // Periodo de una vuelta: 5120 ciclos
        repeat (5116) @(negedge clk);

        // Segunda deteccion Hall
        pulso_hall();

        // Observar las posiciones angulares
        repeat (3500) @(negedge clk);

        $display("=== RESULTADOS ===");

        $display("Angulo horas: %0d", angulo_hor);
        $display("Angulo minutos: %0d", angulo_min);
        $display("Angulo segundos: %0d", angulo_seg);

        $display("Coincidencia en 64: %0d", prueba_64);
        $display("Coincidencia en 128: %0d", prueba_128);

        if (prueba_64 &&
            prueba_128 &&
            errores == 0 &&
            angulo_hor == 64 &&
            angulo_min == 64 &&
            angulo_seg == 128)
            $display("PRUEBA SUPERADA");
        else
            $display("ERROR EN LA INTEGRACION");

        $finish;

    end

endmodule

