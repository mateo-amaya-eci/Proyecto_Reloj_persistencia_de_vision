
`timescale 1ns/1ps

module tb_generador_manecillas_rgb;

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

        MATCH_SEG = 1;
        #10;
        $display("Segundos: R=%b G=%b B=%b",
                 LED_R, LED_G, LED_B);

        MATCH_SEG = 0;
        MATCH_MIN = 1;
        #10;
        $display("Minutos: R=%b G=%b B=%b",
                 LED_R, LED_G, LED_B);

        MATCH_MIN = 0;
        MATCH_HORA = 1;
        #10;
        $display("Horas: R=%b G=%b B=%b",
                 LED_R, LED_G, LED_B);

        MATCH_SEG = 1;
        MATCH_MIN = 1;
        MATCH_HORA = 1;
        #10;
        $display("Coincidencia: R=%b G=%b B=%b",
                 LED_R, LED_G, LED_B);

        $finish;
    end

endmodule
