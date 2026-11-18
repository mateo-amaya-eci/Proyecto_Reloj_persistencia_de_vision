
`timescale 1ns/1ps

module tb_top_leds_integrados;

    reg clk = 0;
    reg reset = 1;
    reg sensor_eh = 0;

    // Hora inicial: 3:15:30
    reg [7:0] rtc_seconds = 8'h30;
    reg [7:0] rtc_minutes = 8'h15;
    reg [7:0] rtc_hours = 8'h03;

    reg [7:0] rtc_day = 8'h17;
    reg [7:0] rtc_month = 8'h11;
    reg [7:0] rtc_weekday = 8'h02;
    reg [7:0] rtc_year = 8'h26;

    reg rtc_valid = 0;

    // Salidas RGB
    wire [9:0] led_r;
    wire [9:0] led_g;
    wire [9:0] led_b;

    // Caratula
    wire [3:0] led_caratula;

    // Señales de seguimiento
    wire [7:0] angulo;
    wire match_hor;
    wire match_min;
    wire match_seg;

    integer errores = 0;

    reg prueba_64 = 0;
    reg prueba_128 = 0;
    reg prueba_200 = 0;

    // Reloj: periodo de 10 ns
    always #5 clk = ~clk;

    // Modulo integrado
    top_leds_integrados #(
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

        .led_r(led_r),
        .led_g(led_g),
        .led_b(led_b),
        .led_caratula(led_caratula),

        .angulo(angulo),
        .match_hor(match_hor),
        .match_min(match_min),
        .match_seg(match_seg)
    );

    // Simular deteccion del sensor Hall
    task pulso_hall;
    begin
        sensor_eh = 1;
        repeat (4) @(negedge clk);
        sensor_eh = 0;
    end
    endtask

    // Verificar cada posicion
    always @(negedge clk) begin

        if (!reset) begin

            // HORAS Y MINUTOS
            if (angulo == 8'd64 && !prueba_64) begin
                prueba_64 = 1;

                if (led_r !== 10'b0000000000 ||
                    led_g !== 10'b0000011111 ||
                    led_b !== 10'b0011111111 ||
                    led_caratula !== 4'b1111) begin

                    $display("ERROR EN ANGULO 64");
                    errores = errores + 1;

                end
                else
                    $display("Angulo 64: CORRECTO");
            end

            // SEGUNDOS
            if (angulo == 8'd128 && !prueba_128) begin
                prueba_128 = 1;

                if (led_r !== 10'b1111111111 ||
                    led_g !== 10'b0000000000 ||
                    led_b !== 10'b0000000000 ||
                    led_caratula !== 4'b1111) begin

                    $display("ERROR EN ANGULO 128");
                    errores = errores + 1;

                end
                else
                    $display("Angulo 128: CORRECTO");
            end

            // POSICION SIN MANECILLAS
            if (angulo == 8'd200 && !prueba_200) begin
                prueba_200 = 1;

                if (led_r !== 0 ||
                    led_g !== 0 ||
                    led_b !== 0 ||
                    led_caratula !== 4'b1000) begin

                    $display("ERROR EN ANGULO 200");
                    errores = errores + 1;

                end
                else
                    $display("Angulo 200: CORRECTO");
            end

        end
    end

    initial begin

        $dumpfile("leds_integrados.vcd");
        $dumpvars(0, tb_top_leds_integrados);

        // Reset inicial
        repeat (5) @(negedge clk);
        reset = 0;

        // Cargar hora
        @(negedge clk);
        rtc_valid = 1;

        @(negedge clk);
        rtc_valid = 0;

        // Primera deteccion Hall
        pulso_hall();

        // Segunda deteccion Hall
        repeat (5116) @(negedge clk);
        pulso_hall();

        // Esperar a recorrer mas de 200 posiciones
        repeat (4500) @(negedge clk);

        $display("=== RESULTADO FINAL ===");

        if (prueba_64 &&
            prueba_128 &&
            prueba_200 &&
            errores == 0)
            $display("PRUEBA SUPERADA");
        else begin
            $display("ERROR EN LA INTEGRACION LED");
            $display("Errores: %0d", errores);
            $display("64=%b 128=%b 200=%b",
                prueba_64, prueba_128, prueba_200);
        end

        $finish;
    end

endmodule
