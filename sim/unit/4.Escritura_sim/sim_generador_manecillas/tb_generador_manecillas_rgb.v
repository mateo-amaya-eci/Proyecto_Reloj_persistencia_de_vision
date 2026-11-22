// testbench generado por IA
`timescale 1ns/1ps

module tb_generador_manecillas_rgb;

    integer errores = 0;

    reg MATCH_SEG;
    reg MATCH_MIN;
    reg MATCH_HORA;

    wire [9:0] LED_R;
    wire [9:0] LED_G;
    wire [9:0] LED_B;

    generador_manecillas_rgb dut (
        .MATCH_SEG(MATCH_SEG),
        .MATCH_MIN(MATCH_MIN),
        .MATCH_HORA(MATCH_HORA),
        .LED_R(LED_R),
        .LED_G(LED_G),
        .LED_B(LED_B)
    );

    initial begin
        $dumpfile("sim_rgb.vcd");
        $dumpvars(0, tb_generador_manecillas_rgb);

        MATCH_SEG = 0;
        MATCH_MIN = 0;
        MATCH_HORA = 0;

        #10;
        $display("Apagados: R=%b G=%b B=%b",
                 LED_R, LED_G, LED_B);
        if (LED_R !== 10'b0 || LED_G !== 10'b0 || LED_B !== 10'b0)
            errores = errores + 1;

        MATCH_SEG = 1;
        #10;
        $display("Segundos: R=%b G=%b B=%b",
                 LED_R, LED_G, LED_B);
        if (LED_R !== 10'b1111111111 || LED_G !== 10'b0 || LED_B !== 10'b0)
            errores = errores + 1;

        MATCH_SEG = 0;
        MATCH_MIN = 1;
        #10;
        $display("Minutos: R=%b G=%b B=%b",
                 LED_R, LED_G, LED_B);
        if (LED_R !== 10'b0 || LED_G !== 10'b0 || LED_B !== 10'b0011111111)
            errores = errores + 1;

        MATCH_MIN = 0;
        MATCH_HORA = 1;
        #10;
        $display("Horas: R=%b G=%b B=%b",
                 LED_R, LED_G, LED_B);
        if (LED_R !== 10'b0 || LED_G !== 10'b0000011111 || LED_B !== 10'b0)
            errores = errores + 1;

        MATCH_SEG = 1;
        MATCH_MIN = 1;
        MATCH_HORA = 1;
        #10;
        $display("Coincidencia: R=%b G=%b B=%b",
                 LED_R, LED_G, LED_B);

        if (LED_R !== 10'b1111111111 || LED_G !== 10'b0000011111 ||
            LED_B !== 10'b0011111111)
            errores = errores + 1;

        if (errores != 0)
            $fatal(1, "FAIL: %0d patrones RGB incorrectos", errores);
        $display("PASS: patrones RGB correctos");

        $finish;
    end

endmodule
