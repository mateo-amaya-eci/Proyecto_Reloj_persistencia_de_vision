`timescale 1ns / 1ps

module sistema_hall_tb;

    reg clk;
    reg rst;
    reg sensor_eh;
    wire tick_1_4;

    // Instancia del sistema top
    sistema_hall_top uut (
        .clk(clk),
        .rst(rst),
        .sensor_eh(sensor_eh),
        .tick_1_4(tick_1_4)
    );

    // Reloj maestro de 50 MHz (Periodo de 20ns -> flanco cada 10ns)
    always #10 clk = ~clk;

    // Generador de simulación del sensor Hall a ~60 Hz 
    // (Un pulso cada 16,666,666 ns con reloj de 50MHz, para la prueba usaremos un periodo simulado más corto de 833,333 ciclos = 16.6 ms)
    initial begin
        clk = 0;
        rst = 1;
        sensor_eh = 0;

        $dumpfile("sim_hall.vcd");
        $dumpvars(0, sistema_hall_tb);

        #100;
        rst = 0; // Soltar reset

        // Simular varias revoluciones del motor a 60 Hz
        // Vuelta 1
        #8333330; 
        sensor_eh = 1; #200; sensor_eh = 0;

        // Vuelta 2 (con la misma velocidad para estabilizar el periodo)
        #8333130; 
        sensor_eh = 1; #200; sensor_eh = 0;

        // Vuelta 3 
        #8333130; 
        sensor_eh = 1; #200; sensor_eh = 0;

        #2000000;
        $finish;
    end

endmodule