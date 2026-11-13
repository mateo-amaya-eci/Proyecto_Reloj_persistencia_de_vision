
`timescale 1ns/1ps

module tb_integracion_leds;

    reg [7:0] angulo_actual;
    reg [7:0] angulo_seg;
    reg [7:0] angulo_min;
    reg [7:0] angulo_hora;

    wire [9:0] led_r;
    wire [9:0] led_g;
    wire [9:0] led_b;
    wire [3:0] led_caratula;

    integer errores = 0;

    integracion_leds dut (
        .angulo_actual(angulo_actual),
        .angulo_seg(angulo_seg),
        .angulo_min(angulo_min),
        .angulo_hora(angulo_hora),
        .led_r(led_r),
        .led_g(led_g),
        .led_b(led_b),
        .led_caratula(led_caratula)
    );

    initial begin
        $dumpfile("sim_integracion_leds.vcd");
        $dumpvars(0, tb_integracion_leds);

        angulo_seg  = 8'd64;
        angulo_min  = 8'd128;
        angulo_hora = 8'd192;

        // Comprobar segundos
        angulo_actual = 8'd64;
        #10;
        if (led_r !== 10'b1111111111 ||
            led_g !== 10'b0000000000 ||
            led_b !== 10'b0000000000 ||
            led_caratula !== 4'b1111)
            errores = errores + 1;

        // Comprobar minutos
        angulo_actual = 8'd128;
        #10;
        if (led_r !== 10'b0000000000 ||
            led_g !== 10'b0000000000 ||
            led_b !== 10'b0011111111 ||
            led_caratula !== 4'b1111)
            errores = errores + 1;

        // Comprobar horas
        angulo_actual = 8'd192;
        #10;
        if (led_r !== 10'b0000000000 ||
            led_g !== 10'b0000011111 ||
            led_b !== 10'b0000000000 ||
            led_caratula !== 4'b1111)
            errores = errores + 1;

        // Comprobar un sector sin manecillas
        angulo_actual = 8'd10;
        #10;
        if (led_r !== 0 ||
            led_g !== 0 ||
            led_b !== 0 ||
            led_caratula !== 4'b1000)
            errores = errores + 1;

        // Comprobar coincidencia de manecillas
        angulo_seg  = 8'd64;
        angulo_min  = 8'd64;
        angulo_hora = 8'd64;
        angulo_actual = 8'd64;
        #10;

        if (led_r !== 10'b1111111111 ||
            led_g !== 10'b0000011111 ||
            led_b !== 10'b0011111111)
            errores = errores + 1;

        if (errores == 0)
            $display("INTEGRACION LEDS: PRUEBAS CORRECTAS");
        else
            $display("INTEGRACION LEDS: %0d ERRORES", errores);

        $finish;
    end

endmodule
